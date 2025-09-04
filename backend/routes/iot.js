const express = require('express');
const Tourist = require('../models/Tourist');
const { createAlert } = require('./alerts');

module.exports = function(io) {
  const router = express.Router();

  // Panic Button
  router.post('/panic', async (req, res) => {
    try {
      const { digitalId, latitude, longitude, message } = req.body;

      const tourist = await Tourist.findOne({ digitalId, isActive: true });
      if (!tourist) return res.status(404).json({ success: false, error: 'Tourist not found' });

      const location = { lat: latitude, lng: longitude };

      const alert = await createAlert(digitalId, 'PANIC', 'CRITICAL', location,
        message || 'Emergency panic button activated');

      io.emit('emergency_alert', {
        alertId: alert._id,
        touristId: digitalId,
        touristName: tourist.name,
        location,
        emergencyContacts: tourist.emergencyContacts,
        message: message || 'Emergency panic button activated'
      });

      res.json({
        success: true,
        alertId: alert._id,
        message: 'Emergency alert sent successfully'
      });

    } catch (error) {
      res.status(400).json({ success: false, error: error.message });
    }
  });

  return router;
};
