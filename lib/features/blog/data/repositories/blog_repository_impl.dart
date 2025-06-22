import 'dart:io';
import 'package:bloggg/core/error/exceptions.dart';
import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:bloggg/features/blog/data/models/blog_model.dart';
import 'package:bloggg/features/blog/domain/entities/blog.dart';
import 'package:bloggg/features/blog/domain/repositories/blog_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasources/blog_local_data_source.dart';

class BlogRepositoryImpl implements BlogRepository{
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.connectionChecker, this.blogLocalDataSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics})
  async{

    try{
      if(!await (connectionChecker.isConnected)){
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel= BlogModel(id: const Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now()
      );
      final imageUrl= await blogRemoteDataSource.uploadBlogImage(image: image, blog: blogModel);

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog= await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);

    }on ServerException catch(e){
      return left(Failure(e.message));
    }


  }

  Future<Either<Failure, Blog>> editBlog({
    required String id,
    required File? image,
    required String? imageUrl,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      String finalImageUrl = imageUrl ?? '';
      if (image != null) {
        finalImageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image!,
          blog: BlogModel(
            id: id,
            posterId: posterId,
            title: title,
            content: content,
            imageUrl: finalImageUrl,
            topics: topics,
            updatedAt: DateTime.now(),
          ),
        );
      }

      BlogModel blogModel = BlogModel(
        id: id,
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: finalImageUrl,
        topics: topics,
        updatedAt: DateTime.now(),
      );

      debugPrint('Updating blog with: ${blogModel.toJson()}');
      final editedBlog = await blogRemoteDataSource.editBlog(blogModel);
      return right(editedBlog);
    } on ServerException catch (e) {
      debugPrint('Server error: ${e.message}');
      return left(Failure(e.message));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return left(Failure('Failed to edit blog'));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async{

    try{
      if(!await (connectionChecker.isConnected)){
        final blogs=blogLocalDataSource.loadBlogs();
        return right(blogs);
    }

      final blogs= await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog(String id) async{
    try{
      await blogRemoteDataSource.deleteBlog(id);
      return right(null);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  
}