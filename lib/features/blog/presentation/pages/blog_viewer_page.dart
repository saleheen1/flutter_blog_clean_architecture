import 'package:flutter/material.dart';
import 'package:flutter_blog_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_blog_clean_architecture/core/utils/calculate_reading_time.dart';
import 'package:flutter_blog_clean_architecture/core/utils/format_date.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(
                    fontSize: 24.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.h,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16.h,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  blog.content,
                  style: TextStyle(
                    fontSize: 16.h,
                    height: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
