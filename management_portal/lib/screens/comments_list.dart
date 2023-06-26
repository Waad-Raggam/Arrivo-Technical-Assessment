// UI
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_portal/blocs/comments/comments_bloc.dart';
import 'package:management_portal/blocs/comments/comments_events.dart';
import 'package:management_portal/blocs/comments/comments_states.dart';

class CommentsScreen extends StatelessWidget {
  final int postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments to Post ID: $postId'),
      ),
      body: BlocProvider(
        create: (_) => CommentsBloc(),
        child: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            if (state is CommentsInitial) {
              BlocProvider.of<CommentsBloc>(context).add(FetchComments(postId));
            }
            if (state is CommentsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CommentsLoaded) {
              return ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  final comment = state.comments[index];
                  return ListTile(
                    title: Text(comment.name),
                    subtitle: Text(comment.body),
                  );
                },
              );
            } else if (state is CommentsError) {
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
