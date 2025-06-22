import 'dart:io';

import 'package:bloggg/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

abstract interface class BlogRepository{
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
});
  Future<Either<Failure, List<Blog>>> getAllBlogs();

  // In your BlogRepository abstract class
  Future<Either<Failure, Blog>> editBlog({
    required String id,
    required File? image,
    required String? imageUrl,  // Make this nullable
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
  Future<Either<Failure, void>> deleteBlog(String id);
}