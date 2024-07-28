import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../entities/initilize_entity.dart';
import '../repositories/initilize_repository.dart';

class Initializer {
  InitilizeRepository repository;
  Initializer(this.repository);

  Future<Either<DataState, InitilizeEntity>> initialize() {
    return repository.initialize();
  }
}
