import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntNotifier extends StateNotifier<int> {
  IntNotifier(): super(0);
  
  void change(int value){
    state = value;
  }
}

final bottomNavProvider = StateNotifierProvider<IntNotifier, int>((ref) {
  return IntNotifier();
});