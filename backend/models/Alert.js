const mongoose = require('mongoose');

const alertSchema = new mongoose.Schema({
  touristId: { type: String, required: true, ref: 'Tourist' },
  alertType: { 
    type: String, 
    enum: ['PANIC', 'GEOFENCE_VIOLATION', 'ANOMALY_DETECTED', 'MISSING_PERSON', 'HEALTH_ALERT'],
    required: true 
  },
  severity: { 
    type: String, 
    enum: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'], 
    required: true 
  },
  location: { 
    lat: { type: Number, required: true },
    lng: { type: Number, required: true }
  },
  description: { type: String, required: true },
  status: { 
    type: String, 
    enum: ['ACTIVE', 'ACKNOWLEDGED', 'RESOLVED'], 
    default: 'ACTIVE' 
  },
  respondingOfficer: String,
  responseTime: Date,
  resolution: String,
  createdAt: { type: Date, default: Date.now },
  acknowledgedAt: Date,
  resolvedAt: Date
});

// Index for efficient querying
alertSchema.index({ touristId: 1, status: 1 });
alertSchema.index({ createdAt: -1 });
// Note: location is not GeoJSON; skipping 2dsphere index to avoid errors

module.exports = mongoose.model('Alert', alertSchema);