import 'dart:io';

import 'package:bloggg/core/error/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource{
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
});
  Future<List<BlogModel>> getAllBlogs();

  Future<BlogModel> editBlog(BlogModel blog);


}
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource{
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async{

    try{
      final blogData = await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    }on PostgrestException catch (e){
      throw ServerException(e.message);
    }

    catch (e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> editBlog(BlogModel blog) async {
    try {
      final updateData = blog.toJson()..remove('id'); // Don't try to update ID
      debugPrint('Attempting to update blog ${blog.id} with: $updateData');

      final editedBlogData = await supabaseClient
          .from('blogs')
          .update(updateData)
          .eq('id', blog.id)
          .select()
          .single();

      return BlogModel.fromJson(editedBlogData);
    } on PostgrestException catch (e) {
      debugPrint('Supabase error: ${e.message}');
      debugPrint('Details: ${e.details}');
      throw ServerException(e.message);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw ServerException('Failed to update blog');
    }
  }


  @override
  Future<String> uploadBlogImage({required File image, required BlogModel blog}) async{
    try{
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    }on StorageException catch(e) {
      throw ServerException(e.message);
    } catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async{
    try{
      final blogs = await supabaseClient.from('blogs').select('*, profiles(name)');
      return blogs.map((blog)=>BlogModel.fromJson(blog).copyWith(posterName: blog['profiles']['name'])).toList();
    }on PostgrestException catch (e){
      throw ServerException(e.message);
    }
    catch(e){
      throw ServerException(e.toString());
    }
  }



}