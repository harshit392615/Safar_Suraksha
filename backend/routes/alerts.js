const express = require('express');
const Alert = require('../models/Alert');
const router = express.Router();

// Utility function to create an alert
async function createAlert(touristId, alertType, severity, location, description) {
  const alert = new Alert({ touristId, alertType, severity, location, description });
  await alert.save();
  return alert;
}

// POST /alerts → create a new alert
router.post('/alerts', async (req, res) => {
  try {
    const { touristId, alertType, severity, location, description } = req.body;
    const alert = await createAlert(touristId, alertType, severity, location, description);
    res.status(201).json({ success: true, alert });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /alerts → fetch all alerts
router.get('/alerts', async (req, res) => {
  try {
    const alerts = await Alert.find().populate('touristId');
    res.json({ success: true, alerts });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = { router, createAlert };
