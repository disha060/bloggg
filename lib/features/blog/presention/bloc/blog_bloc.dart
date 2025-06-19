import 'dart:io';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:bloggg/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/blog.dart';
import '../../domain/usecases/edit_blog.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final EditBlog _editBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required EditBlog editBlog
  }) : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
       _editBlog = editBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogEdit> (_onBlogEdit);
  }

  void _onBlogEdit(
      BlogEdit event,
      Emitter<BlogState> emit,
      ) async {
    emit(BlogLoading());
    final res = await _editBlog(
      EditBlogParams(
        id: event.id,
        image: event.image,
        imageUrl: event.imageUrl,
        title: event.title,
        content: event.content,
        posterId: event.posterId,
        topics: event.topics,
      ),
    );
    res.fold(
          (l) => emit(BlogFailure(l.message)),
          (r) => emit(BlogEditSuccess(r)),
    );
  }


  void _onBlogUpload(
      BlogUpload event,
      Emitter<BlogState> emit,
      ) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
          (l) => emit(BlogFailure(l.message)),
          (r) => emit(BlogUploadSuccess()),
    );
  }
  void _onFetchAllBlogs(
      BlogFetchAllBlogs event,
      Emitter<BlogState> emit,
      ) async{
    final res=await _getAllBlogs(NoParams());

    res.fold((l)=> emit(BlogFailure(l.message)), (r)=>emit(BlogsDisplaySuccess(r)));


  }
}