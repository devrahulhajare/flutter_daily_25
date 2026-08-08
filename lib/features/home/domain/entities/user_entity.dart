import 'package:equatable/equatable.dart';

import 'user_profile_details.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.city,
    required this.state,
    required this.country,
    required this.streetLine,
    required this.nationality,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.matchPercent,
    required this.trustPercent,
    required this.replyTime,
    required this.occupation,
    required this.height,
    required this.intention,
    required this.distanceKm,
    required this.isOnline,
    required this.isVerified,
    required this.gender,
    required this.birthDateIso,
    required this.details,
  });

  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final int age;
  final String city;
  final String state;
  final String country;
  final String streetLine;
  final String nationality;
  final String email;
  final String phone;
  final String imageUrl;
  final String thumbnailUrl;
  final int matchPercent;
  final int trustPercent;
  final String replyTime;
  final String occupation;
  final String height;
  final String intention;
  final double distanceKm;
  final bool isOnline;
  final bool isVerified;
  final String gender;
  final String? birthDateIso;
  final UserProfileDetails details;

  String get displayName => firstName;

  String get fullName {
    final parts = [firstName, lastName].where((p) => p.isNotEmpty);
    return parts.join(' ');
  }

  String get locationLine {
    final distance = '${distanceKm.toStringAsFixed(0)} km away';
    return '$city · $distance';
  }

  String get locationSubtitle {
    final parts = <String>[
      if (city.isNotEmpty) city,
      if (state.isNotEmpty && state != city) state,
      if (country.isNotEmpty) country,
    ];
    return parts.join(', ');
  }

  String get workLine => '$occupation · $height';

  String get bigDreamTitle =>
      gender.toLowerCase() == 'male' ? 'HIS BIG DREAM' : 'HER BIG DREAM';

  @override
  List<Object?> get props => [
        id,
        title,
        firstName,
        lastName,
        age,
        city,
        state,
        country,
        streetLine,
        nationality,
        email,
        phone,
        imageUrl,
        thumbnailUrl,
        matchPercent,
        trustPercent,
        replyTime,
        occupation,
        height,
        intention,
        distanceKm,
        isOnline,
        isVerified,
        gender,
        birthDateIso,
        details,
      ];
}
