import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/user_model.dart';
import 'package:billkeep/utils/id_generator.dart';

class UserRepository {
  final AppDatabase _database;

  UserRepository(this._database);

  Future<String> createUser(UserModel user) async {
    final tempId = IdGenerator.tempUser();
    try {
      await _database
          .into(_database.users)
          .insert(user.toCompanion(id: user.id ?? tempId));
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
    return user.id ?? tempId;
  }

  Future<UserModel?> getUserById(String id) async {
    final userRecord = await (_database.select(
      _database.users,
    )..where((w) => w.id.equals(id))).getSingleOrNull();
    if (userRecord != null) {
      return UserModel.fromDrift(userRecord);
    }
    return null;
  }

  Future<String> updateUser(UserModel user) async {
    if (user.id == null) {
      throw ArgumentError('Cannot update user without an ID');
    }
    try {
      await (_database.update(
        _database.users,
      )..where((tbl) => tbl.id.equals(user.id!))).write(user.toCompanion());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }

    return user.id!;
  }

  Future<void> deleteUser(String id) async {
    try {
      await (_database.delete(
        _database.users,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
