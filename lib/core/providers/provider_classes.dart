import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoolNotifier extends StateNotifier<bool> {
  BoolNotifier(): super(false);

  void change(bool value){
    state = value;
  }
  
}