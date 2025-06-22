
part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}


final class BlogUpload extends BlogEvent{
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics
  });
}
final class BlogEdit extends BlogEvent {
  final String id;
  final File? image;
  final String? imageUrl; // Changed to nullable
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  BlogEdit({
    required this.id,
    this.image,
    this.imageUrl, // Now optional
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent{}

final class BlogDelete extends BlogEvent {
  final String id;

  BlogDelete({required this.id});
}