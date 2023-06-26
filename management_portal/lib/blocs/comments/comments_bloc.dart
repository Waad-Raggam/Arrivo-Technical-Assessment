import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:management_portal/blocs/comments/comments_events.dart';
import 'package:management_portal/blocs/comments/comments_states.dart';
import 'package:management_portal/models/comment.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial());

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is FetchComments) {
      yield CommentsLoading();
      try {
        final response = await http.get(Uri.parse(
            'https://jsonplaceholder.typicode.com/posts/${event.postId}/comments'));
        print("the resp" + response.request.toString());
        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body);
          final comments =
              responseData.map((json) => Comment.fromJson(json)).toList();
          yield CommentsLoaded(comments);
        } else {
          yield CommentsError('Failed to fetch comments');
        }
      } catch (e) {
        yield CommentsError('Failed to fetch comments: $e');
      }
    }
  }

  void getComments(int postId) {
    add(FetchComments(postId));
  }
}
