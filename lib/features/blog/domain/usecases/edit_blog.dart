import 'dart:io';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/blog_repository.dart';

class EditBlog implements UseCase<Blog, EditBlogParams>{
  BlogRepository blogRepository;
  EditBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(EditBlogParams params) async{
    return await blogRepository.editBlog(
        id: params.id,
        image: params.image,
        imageUrl: params.imageUrl,
        title: params.title,
        content: params.content,
        posterId: params.posterId,
        topics: params.topics
    );
  }
}
class EditBlogParams {
  final String id;
  final File? image;
  final String? imageUrl;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  EditBlogParams({
    required this.id,
    this.image,
    this.imageUrl,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}