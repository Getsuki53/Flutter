//ADAPTAR AL BACKEND
import 'package:Flutter/src/model/producto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowedNotifier extends StateNotifier<List<Producto>> {
  FollowedNotifier() : super([]);

  void toggleFollow(Producto product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFollowed(Producto product) {
    return state.any((p) => p.id == product.id);
  }

  void removeFollow(int productId) {
    state = state.where((p) => p.id != productId).toList();
  }
}

final followedProvider = StateNotifierProvider<FollowedNotifier, List<Producto>>((ref) {
  return FollowedNotifier();
});
