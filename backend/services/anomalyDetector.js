class AnomalyDetector {
  constructor() {
    this.locationHistory = new Map();
    this.behaviorPatterns = new Map();
  }

  analyzeLocationPattern(touristId, currentLocation, expectedLocation = null) {
    const history = this.locationHistory.get(touristId) || [];
    const locationPoint = {
      ...currentLocation,
      timestamp: Date.now()
    };
    
    history.push(locationPoint);
    
    // Keep only last 100 locations to manage memory
    if (history.length > 100) {
      history.shift();
    }
    
    this.locationHistory.set(touristId, history);

    const anomalies = [];

    // 1. Sudden movement detection
    if (history.length >= 2) {
      const suddenMovementAnomaly = this.detectSuddenMovement(history);
      if (suddenMovementAnomaly) anomalies.push(suddenMovementAnomaly);
    }

    // 2. Prolonged inactivity detection
    if (history.length >= 5) {
      const inactivityAnomaly = this.detectProlongedInactivity(history);
      if (inactivityAnomaly) anomalies.push(inactivityAnomaly);
    }

    // 3. Route deviation detection
    if (expectedLocation) {
      const routeDeviationAnomaly = this.detectRouteDeviation(currentLocation, expectedLocation);
      if (routeDeviationAnomaly) anomalies.push(routeDeviationAnomaly);
    }

    // 4. Time-based behavior analysis
    const timeAnomaly = this.analyzeTimeBasedBehavior(touristId, currentLocation);
    if (timeAnomaly) anomalies.push(timeAnomaly);

    // 5. Speed analysis
    if (history.length >= 3) {
      const speedAnomaly = this.analyzeSpeedPattern(history);
      if (speedAnomaly) anomalies.push(speedAnomaly);
    }

    return anomalies;
  }

  detectSuddenMovement(history) {
    const latest = history[history.length - 1];
    const previous = history[history.length - 2];
    
    const distance = this.calculateDistance(previous, latest);
    const timeDiff = (latest.timestamp - previous.timestamp) / 1000 / 60; // minutes
    const speed = distance / (timeDiff / 60); // km/h
    
    // Unrealistic speed (faster than 120 km/h for ground transport)
    if (speed > 120 && timeDiff < 60) {
      return {
        type: 'SUDDEN_MOVEMENT',
        severity: 'HIGH',
        description: `Unrealistic movement speed: ${speed.toFixed(2)} km/h over ${timeDiff.toFixed(1)} minutes`,
        data: { speed, distance, timeDiff }
      };
    }

    // Very fast movement in short time
    if (distance > 10 && timeDiff < 10) {
      return {
        type: 'RAPID_DISPLACEMENT',
        severity: 'MEDIUM',
        description: `Rapid displacement: ${distance.toFixed(2)}km in ${timeDiff.toFixed(1)} minutes`,
        data: { speed, distance, timeDiff }
      };
    }

    return null;
  }

  detectProlongedInactivity(history) {
    const recentLocations = history.slice(-5);
    const maxDistance = Math.max(
      ...recentLocations.slice(1).map((loc, i) => 
        this.calculateDistance(recentLocations[i], loc)
      )
    );
    
    if (maxDistance < 0.05) { // Less than 50m movement
      const timeSinceFirstReading = (Date.now() - recentLocations[0].timestamp) / 1000 / 60 / 60; // hours
      
      if (timeSinceFirstReading > 4) {
        return {
          type: 'PROLONGED_INACTIVITY',
          severity: timeSinceFirstReading > 8 ? 'HIGH' : 'MEDIUM',
          description: `No significant movement for ${timeSinceFirstReading.toFixed(1)} hours`,
          data: { inactivityHours: timeSinceFirstReading, maxMovement: maxDistance * 1000 }
        };
      }
    }

    return null;
  }

  detectRouteDeviation(currentLocation, expectedLocation) {
    const deviationDistance = this.calculateDistance(currentLocation, expectedLocation);
    
    if (deviationDistance > 5) { // More than 5km from expected location
      return {
        type: 'ROUTE_DEVIATION',
        severity: deviationDistance > 20 ? 'HIGH' : 'MEDIUM',
        description: `Tourist is ${deviationDistance.toFixed(2)}km away from expected location`,
        data: { deviationDistance, expectedLocation, currentLocation }
      };
    }

    return null;
  }

  analyzeTimeBasedBehavior(touristId, currentLocation) {
    const currentHour = new Date().getHours();
    
    // Movement during very late night hours (2 AM - 5 AM)
    if (currentHour >= 2 && currentHour <= 5) {
      return {
        type: 'UNUSUAL_TIME_ACTIVITY',
        severity: 'MEDIUM',
        description: `Tourist active during late night hours (${currentHour}:00)`,
        data: { hour: currentHour }
      };
    }

    return null;
  }

  analyzeSpeedPattern(history) {
    const recent = history.slice(-3);
    const speeds = [];

    for (let i = 1; i < recent.length; i++) {
      const distance = this.calculateDistance(recent[i-1], recent[i]);
      const timeDiff = (recent[i].timestamp - recent[i-1].timestamp) / 1000 / 60 / 60; // hours
      const speed = distance / timeDiff;
      speeds.push(speed);
    }

    const avgSpeed = speeds.reduce((a, b) => a + b, 0) / speeds.length;
    const maxSpeed = Math.max(...speeds);

    // Consistently high speed might indicate vehicle transport in restricted area
    if (avgSpeed > 60) {
      return {
        type: 'HIGH_SPEED_PATTERN',
        severity: 'MEDIUM',
        description: `Consistent high-speed movement detected (avg: ${avgSpeed.toFixed(2)} km/h)`,
        data: { averageSpeed: avgSpeed, maxSpeed, speeds }
      };
    }

    return null;
  }

  calculateDistance(loc1, loc2) {
    const R = 6371; // Earth's radius in km
    const dLat = this.toRadians(loc2.lat - loc1.lat);
    const dLon = this.toRadians(loc2.lng - loc1.lng);
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(this.toRadians(loc1.lat)) * Math.cos(this.toRadians(loc2.lat)) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
  }

  toRadians(degrees) {
    return degrees * (Math.PI/180);
  }

  // Get analytics for a specific tourist
  getTouristAnalytics(touristId) {
    const history = this.locationHistory.get(touristId) || [];
    if (history.length === 0) return null;

    const totalDistance = history.slice(1).reduce((total, location, index) => {
      return total + this.calculateDistance(history[index], location);
    }, 0);

    const timespan = (history[history.length - 1].timestamp - history[0].timestamp) / 1000 / 60 / 60;
    const averageSpeed = totalDistance / timespan;

    return {
      totalLocations: history.length,
      totalDistance: totalDistance.toFixed(2),
      timespan: timespan.toFixed(2),
      averageSpeed: averageSpeed.toFixed(2),
      lastUpdate: new Date(history[history.length - 1].timestamp)
    };
  }

  // Clear old data to manage memory
  cleanup() {
    const oneDayAgo = Date.now() - (24 * 60 * 60 * 1000);
    
    for (const [touristId, history] of this.locationHistory.entries()) {
      const recentHistory = history.filter(location => location.timestamp > oneDayAgo);
      
      if (recentHistory.length === 0) {
        this.locationHistory.delete(touristId);
      } else {
        this.locationHistory.set(touristId, recentHistory);
      }
    }
  }
}

// Export a singleton instance to keep history in-memory across requests
module.exports = new AnomalyDetector();