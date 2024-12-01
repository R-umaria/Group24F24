//Andy Guest - Nov 20 2024
//backend functionality for the awards

import 'package:flutter/material.dart';

class Award {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  bool isUnlocked;
  final DateTime? unlockedDate;

  Award({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedDate,
  });
}

//holds the trip data of the last trip (temporary until actual trip data file is made)
class TripData {
  final int safeSpeedPercentage;
  final int warningSpeedPercentage;
  final int dangerousSpeedPercentage;
  final double tripScore;
  final bool hasHarshCornering;
  final bool hasHarshAcceleration;

  TripData({
    required this.safeSpeedPercentage,
    required this.warningSpeedPercentage,
    required this.dangerousSpeedPercentage,
    required this.tripScore,
    required this.hasHarshCornering,
    required this.hasHarshAcceleration,
  });
}

//holds all the award info, we can add more awards if wanted
class AwardsManager {
  final List<Award> awards = [
    Award(
      id: 'perfect_speed',
      name: 'Perfect Speed',
      description: 'Stay in the safe speed zone for 100% of the trip',
      icon: Icons.speed_rounded,
      isUnlocked: true,
    ),
    Award(
      id: 'perfect_trip',
      name: 'Perfect Trip',
      description: 'Achieve a 100% trip score',
      icon: Icons.check,
    ),
    Award(
      id: 'excellent_week',
      name: 'Excellent Week',
      description: 'Get 7 perfect trip scores in a week',
      icon: Icons.calendar_month_rounded,
    ),
    Award(
      id: 'consistent_driver',
      name: 'Consistent Driver',
      description: 'Get 7 trip scores above 80% in a row',
      icon: Icons.auto_graph_rounded,
    ),
    Award(
      id: 'smooth_moves',
      name: 'Smooth Moves',
      description: 'Complete 10 trips without harsh cornering or acceleration',
      icon: Icons.circle_rounded,
    ),
    Award(
      id: 'driving_master',
      name: 'Driving Master',
      description: 'Complete 50 trips with an average score above 90%',
      icon: Icons.star,
    ),
  ];

  void processTrip(TripData tripData) {
    //for perfect speed award
    if (tripData.safeSpeedPercentage == 100) {
      unlockAward('perfect_speed');
    }

    //for perfect trip award
    if (tripData.tripScore == 100) {
      unlockAward('perfect_trip');
    }

    //im not adding the rest of the award functionality yet bc i need the info from others
  }

  void unlockAward(String awardId) {
    final award = awards.firstWhere((a) => a.id == awardId);
    if (!award.isUnlocked) {
      award.isUnlocked = true;
    }
  }

  List<Award> getUnlockedAwards() {
    return awards.where((award) => award.isUnlocked).toList();
  }

  List<Award> getLockedAwards() {
    return awards.where((award) => !award.isUnlocked).toList();
  }
}