
class HandleResponse<T> {
  Status? status;
  T? data;
  String? message;

  HandleResponse.loading(this.message) : status = Status.LOADING;
  HandleResponse.completed(this.data) : status = Status.COMPLETED;
  HandleResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }