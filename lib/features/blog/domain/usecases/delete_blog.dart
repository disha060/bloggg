import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams>{
  final BlogRepository blogRepository;
  DeleteBlog(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async{
    return await blogRepository.deleteBlog(params.id);
  }
}
class DeleteBlogParams{
  final String id;
  DeleteBlogParams(this.id);
}