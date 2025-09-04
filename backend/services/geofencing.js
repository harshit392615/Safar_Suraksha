const RiskZone = require('../models/RiskZone');

class GeofenceManager {
  static async checkGeofenceViolation(location, touristId) {
    try {
      const riskZones = await RiskZone.find({ isActive: true });
      
      for (const zone of riskZones) {
        if (this.isPointInPolygon(location, zone.coordinates[0])) {
          return {
            violated: true,
            zone: zone,
            riskLevel: zone.riskLevel
          };
        }
      }
      
      return { violated: false };
    } catch (error) {
      console.error('Geofence check error:', error);
      return { violated: false };
    }
  }

  static isPointInPolygon(point, polygon) {
    let inside = false;
    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if (((polygon[i].lat > point.lat) !== (polygon[j].lat > point.lat)) &&
          (point.lng < (polygon[j].lng - polygon[i].lng) * (point.lat - polygon[i].lat) / (polygon[j].lat - polygon[i].lat) + polygon[i].lng)) {
        inside = !inside;
      }
    }
    return inside;
  }
}

module.exports = GeofenceManager;