import 'package:bloggg/core/common/utils/show_snackbar.dart';
import 'package:bloggg/core/theme/app_pallete.dart';
import 'package:bloggg/features/blog/presention/pages/add_new_page.dart';
import 'package:bloggg/features/blog/presention/provider/blog_provider.dart';
import 'package:bloggg/features/blog/presention/widgets/blog_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:path/path.dart';
import '../../../../core/common/widgets/loader.dart';
import '../widgets/blog_card.dart';


class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();

    // Call fetchAllBlogs() once after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogProvider>().fetchAllBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, _) {
          if (blogProvider.isLoading) {
            return const Loader();
          }

          if (blogProvider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, blogProvider.error!);
            });
          }

          final blogs = blogProvider.blogs;

          if (blogs.isEmpty) {
            return const Center(child: Text("No blogs available."));
          }

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              final color = index % 3 == 0
                  ? AppPallete.gradient1
                  : index % 3 == 1
                  ? AppPallete.gradient2
                  : AppPallete.gradient3;

              return BlogCard(blog: blog, color: color);
            },
          );
        },
      ),
    );
  }
}

