import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  GetUsersUseCase(this._repository);

  final UserRepository _repository;

  Future<List<UserEntity>> call({int results = 20}) {
    return _repository.getUsers(results: results);
  }
}
