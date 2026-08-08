import 'package:flutter_test/flutter_test.dart';
import 'package:daily_25/features/home/data/models/user_model.dart';

void main() {
  test('maps randomuser.me sample payload fields correctly', () {
    final json = {
      "gender": "female",
      "name": {"title": "Ms", "first": "Rosa", "last": "Rasmussen"},
      "location": {
        "street": {"number": 9698, "name": "Ågerupvej"},
        "city": "Askeby",
        "state": "Danmark",
        "country": "Denmark",
        "postcode": 27023,
      },
      "email": "rosa.rasmussen@example.com",
      "login": {"uuid": "cec5ff12-33f7-4504-9f3b-889601a36b1c"},
      "dob": {"date": "1979-12-18T19:02:11.587Z", "age": 46},
      "phone": "16146087",
      "cell": "73550963",
      "picture": {
        "large": "https://randomuser.me/api/portraits/women/0.jpg",
        "medium": "https://randomuser.me/api/portraits/med/women/0.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/0.jpg"
      },
      "nat": "DK"
    };

    final user = UserModel.fromJson(json);

    expect(user.id, 'cec5ff12-33f7-4504-9f3b-889601a36b1c');
    expect(user.firstName, 'Rosa');
    expect(user.lastName, 'Rasmussen');
    expect(user.age, 46);
    expect(user.details.birthDateLabel, '18 Dec 1979');
    expect(user.city, 'Askeby');
    expect(user.state, 'Danmark');
    expect(user.country, 'Denmark');
    expect(user.streetLine, '9698 Ågerupvej');
    expect(user.details.neighborhood, 'Askeby');
    expect(user.details.locationRegion, 'Danmark, Denmark');
    expect(user.locationSubtitle, 'Askeby, Danmark, Denmark');
    expect(user.nationality, 'DK');
    expect(user.details.motherTongue, 'Danish');
    expect(user.details.zodiac, 'Sagittarius');
    expect(user.imageUrl, 'https://randomuser.me/api/portraits/women/0.jpg');
    expect(user.email, 'rosa.rasmussen@example.com');
    expect(user.phone, '16146087');
    expect(user.gender, 'female');
  });
}
