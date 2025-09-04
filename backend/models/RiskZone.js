const mongoose = require('mongoose');

const riskZoneSchema = new mongoose.Schema({
  name: { type: String, required: true },
  coordinates: {
    type: [{
      type: [{ lat: Number, lng: Number }],
      required: true
    }],
    required: true
  },
  riskLevel: { 
    type: String, 
    enum: ['LOW', 'MEDIUM', 'HIGH'], 
    required: true 
  },
  description: String,
  restrictions: [String],
  alertMessage: String,
  isActive: { type: Boolean, default: true },
  createdBy: String,
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Note: coordinates stored as array of {lat,lng}; skipping 2dsphere until GeoJSON

module.exports = mongoose.model('RiskZone', riskZoneSchema);