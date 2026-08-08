import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers({int results = 20});
}
