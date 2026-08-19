class SeniorProfileModel {
  final String id;
  final int? age;
  final double? homeLat;
  final double? homeLng;
  final String? homeAddress;
  final String? wakeTime;
  final String? sleepTime;
  final List<dynamic>? mealTimes;
  final List<dynamic>? activityPeriods;
  final String? notes;

  SeniorProfileModel({
    required this.id,
    this.age,
    this.homeLat,
    this.homeLng,
    this.homeAddress,
    this.wakeTime,
    this.sleepTime,
    this.mealTimes,
    this.activityPeriods,
    this.notes,
  });

  factory SeniorProfileModel.fromJson(Map<String, dynamic> json) {
    return SeniorProfileModel(
      id: json['id'] as String,
      age: json['age'] as int?,
      homeLat: (json['home_lat'] as num?)?.toDouble(),
      homeLng: (json['home_lng'] as num?)?.toDouble(),
      homeAddress: json['home_address'] as String?,
      wakeTime: json['wake_time'] as String?,
      sleepTime: json['sleep_time'] as String?,
      mealTimes: json['meal_times'] as List<dynamic>?,
      activityPeriods: json['activity_periods'] as List<dynamic>?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'home_lat': homeLat,
      'home_lng': homeLng,
      'home_address': homeAddress,
      'wake_time': wakeTime,
      'sleep_time': sleepTime,
      'meal_times': mealTimes ?? [],
      'activity_periods': activityPeriods ?? [],
      'notes': notes,
    };
  }
}
