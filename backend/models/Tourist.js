const mongoose = require('mongoose');

const touristSchema = new mongoose.Schema({
  digitalId: { type: String, unique: true, required: true },
  passportNumber: { type: String, required: true },
  aadhaarNumber: { type: String, required: true },
  name: { type: String, required: true },
  nationality: { type: String, required: true },
  phoneNumber: { type: String, required: true },
  emergencyContacts: [{
    name: { type: String, required: true },
    phone: { type: String, required: true },
    relationship: { type: String, required: true }
  }],
  itinerary: [{
    location: String,
    checkIn: Date,
    checkOut: Date,
    coordinates: { lat: Number, lng: Number }
  }],
  safetyScore: { type: Number, default: 70, min: 0, max: 100 },
  currentLocation: {
    lat: { type: Number, required: false },
    lng: { type: Number, required: false },
    timestamp: { type: Date, default: Date.now }
  },
  vitals: {
    heartRate: Number,
    batteryLevel: Number,
    lastUpdate: Date
  },
  isActive: { type: Boolean, default: true },
  riskLevel: { type: String, enum: ['LOW', 'MEDIUM', 'HIGH'], default: 'LOW' },
  deviceId: String, // For IoT device linking
  createdAt: { type: Date, default: Date.now },
  expiresAt: { type: Date, required: true }
});

// Note: currentLocation uses lat/lng object, not GeoJSON; skipping 2dsphere index

// TTL index for automatic cleanup of expired tourists
touristSchema.index({ "expiresAt": 1 }, { expireAfterSeconds: 0 });

module.exports = mongoose.model('Tourist', touristSchema);