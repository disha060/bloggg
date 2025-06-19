import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

import '../entities/blog.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async{
    return await blogRepository.getAllBlogs();
  }

}