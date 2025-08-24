import 'package:bloggg/core/common/utils/calculate_reading_time.dart';
import 'package:bloggg/core/common/utils/format_date.dart';
import 'package:bloggg/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/provider/app_user/app_user_provider.dart';
import '../../domain/entities/blog.dart';
import '../provider/blog_provider.dart';
import 'add_new_page.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        context.read<AppUserProvider>().user?.id ?? '';
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
                    SizedBox(
                      width: 250,
                      child: Text(
                        blog.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            AddNewBlogPage.route(blogToEdit: blog),
                          );
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this blog?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete ?? false) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                                child: CircularProgressIndicator()),
                          );

                          try {
                            await context
                                .read<BlogProvider>()
                                .deleteBlog(blog.id);
                            await context
                                .read<BlogProvider>()
                                .fetchAllBlogs();

                            if (Navigator.canPop(context)) {
                              Navigator.pop(context); // loading dialog
                              Navigator.pop(context); // viewer page
                            }
                          } catch (e) {
                            Navigator.pop(context); // Close loader
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Delete failed: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)} · ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(blog.title,
                    style: const TextStyle(fontSize: 16, height: 2)),
                Text(blog.content,
                    style: const TextStyle(fontSize: 16, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
