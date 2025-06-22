part of 'blog_bloc.dart';

@immutable
sealed class BlogState {
  const BlogState();  // Add const constructor here
}

final class BlogInitial extends BlogState {
  const BlogInitial();  // Add const constructor
}

final class BlogLoading extends BlogState {
  const BlogLoading();  // Add const constructor
}

class BlogFailure extends BlogState {
  final String error;

  const BlogFailure(this.error);  // Made constructor const

  @override
  List<Object?> get props => [error];
}

final class BlogUploadSuccess extends BlogState {
  const BlogUploadSuccess();  // Add const constructor
}

final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;

  const BlogsDisplaySuccess(this.blogs);  // Made constructor const
}

final class BlogEditSuccess extends BlogState {
  final Blog blog;

  const BlogEditSuccess(this.blog);  // Made constructor const
}

class BlogDeleteSuccess extends BlogState {
  final String deletedId;

  const BlogDeleteSuccess(this.deletedId);  // Now properly const

  @override
  List<Object> get props => [deletedId];
}