import '../../../../core/utils/profile_enrichment.dart';
import '../../domain/entities/user_entity.dart';
import '../utils/profile_details_factory.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.title,
    required super.firstName,
    required super.lastName,
    required super.age,
    required super.city,
    required super.state,
    required super.country,
    required super.streetLine,
    required super.nationality,
    required super.email,
    required super.phone,
    required super.imageUrl,
    required super.thumbnailUrl,
    required super.matchPercent,
    required super.trustPercent,
    required super.replyTime,
    required super.occupation,
    required super.height,
    required super.intention,
    required super.distanceKm,
    required super.isOnline,
    required super.isVerified,
    required super.gender,
    required super.birthDateIso,
    required super.details,
  });

  /// Maps a single item from `https://randomuser.me/api/?results=20`.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = _map(json['name']);
    final dob = _map(json['dob']);
    final location = _map(json['location']);
    final street = _map(location['street']);
    final picture = _map(json['picture']);
    final login = _map(json['login']);

    final firstName = _text(name['first'], fallback: 'User');
    final lastName = _text(name['last']);
    final uuid = _text(login['uuid']);
    final id = uuid.isNotEmpty
        ? uuid
        : '${firstName}_${lastName}_${dob['age']}';

    final gender = _text(json['gender'], fallback: 'female').toLowerCase();
    final city = _text(location['city'], fallback: 'Nearby');
    final state = _text(location['state']);
    final country = _text(location['country']);
    final streetNumber = street['number'];
    final streetName = _text(street['name']);
    final streetLine = [
      if (streetNumber != null) '$streetNumber',
      if (streetName.isNotEmpty) streetName,
    ].join(' ').trim();

    final birthDateIso = _text(dob['date']).isEmpty ? null : _text(dob['date']);
    final age = (dob['age'] as num?)?.toInt() ?? 25;
    final imageUrl = _text(picture['large']).isNotEmpty
        ? _text(picture['large'])
        : _text(picture['medium']);
    final thumbnailUrl = _text(picture['thumbnail']).isNotEmpty
        ? _text(picture['thumbnail'])
        : imageUrl;

    final occupation = ProfileEnrichment.occupation(id);
    final height = ProfileEnrichment.height(id);

    return UserModel(
      id: id,
      title: _text(name['title']),
      firstName: firstName,
      lastName: lastName,
      age: age,
      city: city,
      state: state,
      country: country,
      streetLine: streetLine,
      nationality: _text(json['nat']).toUpperCase(),
      email: _text(json['email']),
      phone: _text(json['phone']).isNotEmpty
          ? _text(json['phone'])
          : _text(json['cell']),
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
      matchPercent: ProfileEnrichment.matchPercent(id),
      trustPercent: ProfileEnrichment.trustPercent(id),
      replyTime: ProfileEnrichment.replyTime(id),
      occupation: occupation,
      height: height,
      intention: ProfileEnrichment.intention(id),
      distanceKm: ProfileEnrichment.distanceKm(id),
      isOnline: ProfileEnrichment.isOnline(id),
      isVerified: ProfileEnrichment.isVerified(id),
      gender: gender,
      birthDateIso: birthDateIso,
      details: ProfileDetailsFactory.build(
        seed: id,
        occupation: occupation,
        height: height,
        gender: gender,
        nationality: _text(json['nat']).toUpperCase(),
        streetLine: streetLine,
        city: city,
        state: state,
        country: country,
        birthDateIso: birthDateIso,
      ),
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  static String _text(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }
}
