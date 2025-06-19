import 'dart:io';
import 'package:bloggg/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:bloggg/core/common/utils/pick_image.dart';
import 'package:bloggg/core/common/utils/show_snackbar.dart';
import 'package:bloggg/features/blog/presention/bloc/blog_bloc.dart';
import 'package:bloggg/features/blog/presention/pages/blog_page.dart';
import 'package:bloggg/features/blog/presention/widgets/blog_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/constants.dart';
import '../../domain/entities/blog.dart';

class AddNewBlogPage extends StatefulWidget {
  final Blog? blogToEdit;
  //static route() => MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  static Route route({Blog? blogToEdit}) =>
      MaterialPageRoute(builder: (_) => AddNewBlogPage(blogToEdit: blogToEdit));

  const AddNewBlogPage({super.key, this.blogToEdit});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;

  Future<void> selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      // Create a permanent copy in app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = File('${appDir.path}/$fileName');

      await savedImage.writeAsBytes(await pickedFile.readAsBytes());

      setState(() {
        image = savedImage;
      });
    } catch (e) {
      showSnackBar(context, "Failed to select image: ${e.toString()}");
    }
  }

  void uploadBlog() {
    try {
      if (!formKey.currentState!.validate()) {
        throw Exception("Please fill all fields correctly");
      }

      if (selectedTopics.isEmpty) {
        throw Exception("Please select at least one topic");
      }

      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      if (widget.blogToEdit != null) {
        // EDIT flow
        final isImageChanged = image != null &&
            !image!.path.contains('temp_image.jpg');

        context.read<BlogBloc>().add(
          BlogEdit(
            id: widget.blogToEdit!.id,
            image: isImageChanged ? image : null,
            imageUrl: isImageChanged ? null : widget.blogToEdit!.imageUrl,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            posterId: posterId,
            topics: selectedTopics,
          ),
        );
      } else {
        // UPLOAD flow
        if (image == null) throw Exception("Please select an image");

        context.read<BlogBloc>().add(
          BlogUpload(
            posterId: posterId,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            image: image!,
            topics: selectedTopics,
          ),
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  @override
  void initState() {
    super.initState();

    final blog = widget.blogToEdit;
    if (blog != null) {
      titleController.text = blog.title;
      contentController.text = blog.content;
      selectedTopics = List.from(blog.topics);

      if (blog.imageUrl.isNotEmpty) {
        _loadImageFromUrl(blog.imageUrl);
      }
    }
  }
  Future<void> _loadImageFromUrl(String imageUrl) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final imageData = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(imageData);

      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, 'temp_image.jpg');
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      setState(() {
        image = file;
      });
    } catch (e) {
      showSnackBar(context, "Failed to load image from network");
    }
  }



  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess || state is BlogEditSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // Image Picker Section
                    GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        height: 150,
                        width: double.infinity,
                        child: image != null
                            ? Image.file(image!, fit: BoxFit.cover)
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.folder_open, size: 40),
                            SizedBox(height: 15),
                            Text('Select your image', style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Topics Section
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics.map((e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedTopics.contains(e)) {
                                  selectedTopics.remove(e);
                                } else {
                                  selectedTopics.add(e);
                                }
                              });
                            },
                            child: Chip(
                              label: Text(e),
                              backgroundColor: selectedTopics.contains(e)
                                  ? Colors.blue[100]
                                  : null,
                              side: selectedTopics.contains(e)
                                  ? null
                                  : const BorderSide(color: Colors.grey),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),

                    // Blog Editor Sections
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}