import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:management_portal/blocs/posts/posts_bloc.dart';
import 'package:management_portal/blocs/posts/posts_event.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';

class SinglePost extends StatelessWidget {
  final int postId;

  const SinglePost({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(PostInitial()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post ID: $postId'),
        ),
        body: BlocProvider(
          create: (_) => PostBloc(PostInitial()),
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostInitial) {
                BlocProvider.of<PostBloc>(context).add(GetPostsById(postId));
              } else if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostLoaded) {
                final posts = state.posts;
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Body')),
                  ],
                  rows: posts
                      .map(
                        (post) => DataRow(
                          cells: [
                            DataCell(Text(post.id.toString())),
                            DataCell(Text(post.title)),
                            DataCell(Text(post.body)),
                          ],
                        ),
                      )
                      .toList(),
                );
              } else if (state is PostError) {
                return Center(child: Text('Error: ${state.error}'));
              }

              return const Center(child: Text('No data available'));
            },
          ),
        ),
      ),
    );
  }
}
