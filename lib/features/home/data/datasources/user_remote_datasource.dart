import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> fetchUsers({int results = 20});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<UserModel>> fetchUsers({int results = 20}) async {
    final json = await _apiClient.get(
      ApiConstants.usersEndpoint(results: results),
    );
    final resultsList = json['results'] as List<dynamic>?;
    if (resultsList == null) {
      throw const ParseFailure();
    }
    if (resultsList.isEmpty) {
      throw const EmptyFailure();
    }

    return resultsList
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }
}
