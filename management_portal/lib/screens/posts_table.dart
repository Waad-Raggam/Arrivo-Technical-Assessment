// UI
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_portal/blocs/blocs.dart';
import 'package:management_portal/blocs/posts/posts_event.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';
import 'package:management_portal/models/comment.dart';
import 'package:management_portal/models/post.dart';
import 'package:management_portal/screens/comments_list.dart';
import 'package:management_portal/screens/new_post.dart';
import 'package:management_portal/screens/single_post.dart';

class PostTable extends StatefulWidget {
  @override
  State<PostTable> createState() => _PostTableState();
}

class _PostTableState extends State<PostTable> {
  dynamic _searchQuery;
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostForm(),
                ),
              ).then((newPost) {
                if (newPost != null) {
                  setState(() {
                    final post = Post.fromJson(newPost);
                    _posts.add(post);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onSubmitted: (value) {
              int postId = int.parse(_searchQuery);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SinglePost(postId: postId),
                ),
              );
            },
            decoration: const InputDecoration(
              hintText: 'Search by ID...',
            ),
          ),
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostInitial) {
                BlocProvider.of<PostBloc>(context).add(FetchPosts());
              } else if (state is PostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PostLoaded) {
                _posts = state.posts;
                return PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Body')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _PostsDataSource(_posts, context),
                );
              } else if (state is PostError) {
                return Center(
                  child: Text(state.error),
                );
              }

              return const Center(child: Text('No data available'));
            },
          ),
        ],
      ),
    );
  }
}

class _PostsDataSource extends DataTableSource {
  final List<dynamic> _posts;
  final BuildContext _context;
  List<Comment> comments = [];

  _PostsDataSource(this._posts, this._context);

  @override
  DataRow getRow(int index) {
    final dynamic post = _posts[index];
    final postId = post is Post ? post.id : post['id'];
    final postTitle = post is Post ? post.title : post['title'];
    final postBody = post is Post ? post.body : post['body'];

    return DataRow(cells: [
      DataCell(Text(postId.toString())),
      DataCell(Text(postTitle)),
      DataCell(Text(postBody)),
      DataCell(
        Row(
          children: [
            TextButton(
              child: const Text('Comments'),
              onPressed: () {
                Navigator.push(
                  _context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(postId: postId),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: _context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this post?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            final int postId =
                                post is Post ? post.id : post['id'];
                            BlocProvider.of<PostBloc>(_context)
                                .deletePost(postId);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  int get rowCount => _posts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
