const express = require('express');
const crypto = require('crypto');
const Tourist = require('../models/Tourist');
const Alert = require('../models/Alert');
const RiskZone = require('../models/RiskZone');
const blockchain = require('../services/blockchain');
const GeofenceManager = require('../services/geofencing');
const anomalyDetector = require('../services/anomalyDetector');
const { createAlert } = require('./alerts');

const router = express.Router();

// Tourist Registration
router.post('/register-tourist', async (req, res) => {
  try {
    const { passportNumber, aadhaarNumber, name, nationality, phoneNumber, emergencyContacts, itinerary, visitDuration } = req.body;

    const digitalId = 'TID_' + crypto.randomBytes(16).toString('hex').toUpperCase();

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + visitDuration);

    const tourist = new Tourist({
      digitalId,
      passportNumber,
      aadhaarNumber,
      name,
      nationality,
      phoneNumber,
      emergencyContacts,
      itinerary,
      expiresAt
    });

    await tourist.save();

    const blockHash = blockchain.addTouristRecord({
      digitalId,
      passportNumber,
      name,
      timestamp: Date.now(),
      expiresAt: expiresAt.getTime()
    });

    res.json({
      success: true,
      digitalId,
      blockHash,
      message: 'Tourist registered successfully',
      qrCode: `data:${digitalId}:${blockHash}`
    });

  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Update Location
router.post('/update-location', async (req, res) => {
  try {
    const { digitalId, latitude, longitude } = req.body;

    const tourist = await Tourist.findOne({ digitalId, isActive: true });
    if (!tourist) return res.status(404).json({ success: false, error: 'Tourist not found' });

    const location = { lat: latitude, lng: longitude, timestamp: Date.now() };

    tourist.currentLocation = location;
    await tourist.save();

    const geofenceCheck = await GeofenceManager.checkGeofenceViolation(location, digitalId);
    const anomalies = anomalyDetector.analyzeLocationPattern(digitalId, location);

    if (geofenceCheck.violated) {
      await createAlert(digitalId, 'GEOFENCE_VIOLATION', geofenceCheck.zone.riskLevel, location,
        `Tourist entered ${geofenceCheck.zone.name} (${geofenceCheck.zone.riskLevel} risk zone)`);
    }

    for (const anomaly of anomalies) {
      await createAlert(digitalId, 'ANOMALY_DETECTED', anomaly.severity, location, anomaly.description);
    }

    const newSafetyScore = calculateSafetyScore(tourist, geofenceCheck, anomalies);
    tourist.safetyScore = newSafetyScore;
    await tourist.save();

    res.json({
      success: true,
      safetyScore: newSafetyScore,
      alerts: geofenceCheck.violated || anomalies.length > 0,
      riskLevel: tourist.riskLevel
    });

  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Dashboard
router.get('/dashboard/tourists', async (req, res) => {
  try {
    const tourists = await Tourist.find({ isActive: true }).select('-aadhaarNumber -passportNumber');
    const alerts = await Alert.find({ status: 'ACTIVE' }).populate('touristId');
    const riskZones = await RiskZone.find({ isActive: true });

    res.json({
      success: true,
      data: {
        tourists,
        activeAlerts: alerts,
        riskZones,
        statistics: {
          totalTourists: tourists.length,
          highRiskTourists: tourists.filter(t => t.riskLevel === 'HIGH').length,
          activeAlerts: alerts.length,
          criticalAlerts: alerts.filter(a => a.severity === 'CRITICAL').length
        }
      }
    });

  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Helper
function calculateSafetyScore(tourist, geofenceCheck, anomalies) {
  let score = tourist.safetyScore || 70;

  if (geofenceCheck.violated) {
    switch (geofenceCheck.zone.riskLevel) {
      case 'HIGH': score -= 30; break;
      case 'MEDIUM': score -= 15; break;
      case 'LOW': score -= 5; break;
    }
  }

  for (const anomaly of anomalies) {
    switch (anomaly.severity) {
      case 'HIGH': score -= 20; break;
      case 'MEDIUM': score -= 10; break;
      case 'LOW': score -= 5; break;
    }
  }

  const currentHour = new Date().getHours();
  if (currentHour >= 22 || currentHour <= 6) score -= 10;

  return Math.max(0, Math.min(100, score));
}

module.exports = router;
