import 'package:event_rush_mobile/models/user.dart';
import 'package:event_rush_mobile/services/api_service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pour UserService (injecté avec baseUrl + token)
final userServiceProvider = Provider<UserService>((ref) {
  // const baseUrl = "http://127.0.0.1:8001/api"; // adapte à ton backend
  // const token = "558|ZUGJ0sAjUGnxmlnDrFKlejop3K0Yh5Nstney1Tbud1e68c87";
  return UserService();
});

// FutureProvider qui charge le user
final userProvider = FutureProvider<User?>((ref) async {
  // final service = ref.watch(userServiceProvider);
  // return await service.getMe();
  // final userService = ref.watch(userServiceProvider);
  // final userData = await userService.getMe();
  // return User.fromJson(userData);
  // final User users = await userService.getMe();
  // return users.isNotEmpty ? users.first : null;
  final userService = ref.read(userServiceProvider);
  final User user = await userService.getMe();
  return user;
});

// StateProvider pour garder le user en mémoire et le modifier si besoin
final userStateProvider = StateProvider<User?>((ref) {
  final asyncUser = ref.watch(userProvider);
  return asyncUser.value; // valeur initiale quand FutureProvider est résolu
});
