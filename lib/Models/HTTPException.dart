class HTTPException implements Exception {
  String message;
  HTTPException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
