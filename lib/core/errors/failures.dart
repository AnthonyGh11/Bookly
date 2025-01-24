import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection Timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send Timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive Timeout with ApiServer');
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioException.response!.statusCode!, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was Cancelled ');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (dioException.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }

        return ServerFailure('Unexpected Error, Please Try Again Later');
      default:
        return ServerFailure(
            'Woops! Something Went Wrong, Please Try Again Later!');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
          'Your Request Was Not Found, Please Try Again Later');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server Error, Please Try Again Later');
    } else {
      return ServerFailure(
          'Woops, There was an Unexpected Error, please try again later!');
    }
  }
}
