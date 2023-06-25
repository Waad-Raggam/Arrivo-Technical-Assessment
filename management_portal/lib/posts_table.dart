// UI
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_portal/blocs/blocs.dart';
import 'package:management_portal/blocs/posts/posts_event.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';

class PostTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostInitial) {
            BlocProvider.of<PostBloc>(context).add(FetchPosts());
          }

          if (state is PostLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PostLoaded) {
            final List<dynamic> posts = state.posts;
            return PaginatedDataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Body')),
                DataColumn(label: Text('Actions')),
              ],
              source: _PostsDataSource(posts, context),
              // rowsPerPage: _perPage,
              // onPageChanged: (pageIndex) {
              //   BlocProvider.of<PostBloc>(context).fetchNextPage();
              // },
            );
          }

          if (state is PostError) {
            return Center(
              child: Text(state.error),
            );
          }

          return Container();
        },
      ),
    );
  }
}

class _PostsDataSource extends DataTableSource {
  final List<dynamic> _posts;
  final BuildContext _context;

  _PostsDataSource(this._posts, this._context);

  @override
  DataRow getRow(int index) {
    final post = _posts[index];
    return DataRow(cells: [
      DataCell(Text(post['id'].toString())),
      DataCell(Text(post['title'])),
      DataCell(Text(post['body'])),
      DataCell(
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: _context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete this post?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () {
                        final int postId = post['id'];
                        BlocProvider.of<PostBloc>(_context).deletePost(postId);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
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
