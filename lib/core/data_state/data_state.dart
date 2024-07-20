abstract class DataState{
  final int status;

  DataState(this.status);
}

class DataFailure extends DataState{
  final String message;

  DataFailure(super.status, this.message);
}

class DataFailureOffline extends DataState{
  final String message;

  DataFailureOffline(super.status, this.message);
}