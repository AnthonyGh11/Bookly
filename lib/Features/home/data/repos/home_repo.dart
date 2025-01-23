import 'package:bookly_app/Features/home/data/models/book_model/book_model.dart';
import 'package:bookly_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<BookModel>>>
      fetchBestSellerBooks(); //the value on the left is the problem, the value on the right is the right type to be returned
  Future<Either<Failure, List<BookModel>>> fetchFeaturedBooks();
}
