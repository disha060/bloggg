import 'package:bloggg/core/common/utils/calculate_reading_time.dart';
import 'package:bloggg/core/common/utils/format_date.dart';
import 'package:bloggg/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../domain/entities/blog.dart';
import '../bloc/blog_bloc.dart';
import 'add_new_page.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog)=> MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog,));
  final Blog blog;


  const BlogViewerPage({super.key, required this.blog});
  @override
  Widget build(BuildContext context) {

    final currentUserId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final bool isOwner = currentUserId == blog.posterId;
    return Scaffold(
        appBar: AppBar(),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(

                    children: [
                      Container(
                          width: 250,
                          child: Text(blog.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),

                      if (isOwner)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            print('edit button tapped');
                            Navigator.push(context, AddNewBlogPage.route(blogToEdit: blog));

                          },
                        ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Show confirmation dialog
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this blog?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete ?? false) {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );

                            // Dispatch delete event
                            context.read<BlogBloc>().add(BlogDelete(id: blog.id));

                            // Wait for either success or failure state
                            await Future.wait([
                              // Wait for the state change
                              context.read<BlogBloc>().stream.firstWhere(
                                    (state) => state is BlogDeleteSuccess || state is BlogFailure,
                              ),
                              // Small delay to ensure smooth transition
                              Future.delayed(const Duration(milliseconds: 300)),
                            ]);

                            // Force refresh the blog list
                            context.read<BlogBloc>().add(BlogFetchAllBlogs());

                            // Navigate back
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context); // Pop loading dialog
                              Navigator.pop(context); // Pop viewer page
                            }
                          }
                        },
                      ),

                    ],
                  ),


                  const SizedBox(height: 20,),
                  Text('By ${blog.posterName}', style: const TextStyle(fontWeight: FontWeight.w500,fontSize:16)),
                  const SizedBox(height: 5,),
                  Text('${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime((blog.content))}min', style: TextStyle(color:  AppPallete.greyColor, fontSize: 16, fontWeight: FontWeight.w500),),

                  SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(blog.imageUrl),
                  ),
                  const SizedBox(height: 20,),
                  Text(blog.title, style: TextStyle(fontSize: 16, height: 2)),
                  Text(blog.content, style: TextStyle(fontSize: 16, height: 2)),

                ],
              ),
            ),
          ),
        ),
      );
  }
}
