import 'dart:io';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:bloggg/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/blog.dart';
import '../../domain/usecases/delete_blog.dart';
import '../../domain/usecases/edit_blog.dart';

class BlogProvider extends ChangeNotifier {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final EditBlog _editBlog;
  final DeleteBlog _deleteBlog;

  BlogProvider({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required EditBlog editBlog,
    required DeleteBlog deleteBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _editBlog = editBlog,
        _deleteBlog = deleteBlog;

  // State Variables
  bool isLoading = false;
  String? error;
  List<Blog> blogs = [];
  Blog? editedBlog;
  String? deletedBlogId;
  bool uploadSuccess = false;

  bool get isSuccess => uploadSuccess || editedBlog != null;

  // Add this method
  void resetState() {
    uploadSuccess = false;
    editedBlog = null;
    error = null;
    notifyListeners();
  }

  // Helpers
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    error = message;
    notifyListeners();
  }

  // Methods
  Future<void> uploadBlog({
    required String posterId,
    required String title,
    required String content,
    required File image,
    required List<String> topics,
  }) async {
    _setLoading(true);
    final res = await _uploadBlog(UploadBlogParams(
      posterId: posterId,
      title: title,
      content: content,
      image: image,
      topics: topics,
    ));
    res.fold(
          (l) {
        _setError(l.message);
        uploadSuccess = false;
      },
          (_) {
        uploadSuccess = true;
      },
    );
    _setLoading(false);
  }

  Future<void> fetchAllBlogs() async {
    _setLoading(true);
    final res = await _getAllBlogs(NoParams());
    res.fold(
          (l) => _setError(l.message),
          (r) {
        blogs = r;
        error = null;
      },
    );
    _setLoading(false);
  }

  Future<void> editBlog({
    required String id,
    File? image,
    String? imageUrl,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    _setLoading(true);
    final res = await _editBlog(EditBlogParams(
      id: id,
      image: image,
      imageUrl: imageUrl,
      title: title,
      content: content,
      posterId: posterId,
      topics: topics,
    ));
    res.fold(
          (l) => _setError(l.message),
          (r) {
        editedBlog = r;
        error = null;
      },
    );
    _setLoading(false);
  }

  Future<void> deleteBlog(String id) async {
    _setLoading(true);
    final res = await _deleteBlog(DeleteBlogParams(id));
    res.fold(
          (l) => _setError(l.message),
          (_) {
        deletedBlogId = id;
        blogs.removeWhere((blog) => blog.id == id);
        error = null;
      },
    );
    _setLoading(false);
  }
}