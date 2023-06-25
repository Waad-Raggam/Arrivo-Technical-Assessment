import 'package:management_portal/blocs/posts/posts_event.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the BLoC
class PostBloc extends Bloc<PostEvent, PostState> {
  static const int _perPage = 10;
  int _currentPage = 1;
  List<dynamic> _posts = [];

  PostBloc(PostState initialState) : super(initialState);

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPosts) {
      yield PostLoading();
      try {
        final response = await http.get(Uri.parse(
            'https://jsonplaceholder.typicode.com/posts?_page=$_currentPage&_limit=$_perPage'));
        if (response.statusCode == 200) {
          final List<dynamic> parsedJson = json.decode(response.body);
          _posts.addAll(parsedJson);
          yield PostLoaded(_posts);
        } else {
          yield PostError('Failed to fetch posts');
        }
      } catch (e) {
        yield PostError('Failed to fetch posts');
      }
    } else if (event is DeletePost) {
      _posts.removeWhere((post) => post['id'] == event.postId);
      yield PostLoaded(_posts);
    }
  }

  void fetchNextPage() {
    _currentPage++;
    add(FetchPosts());
  }

  void deletePost(int postId) {
    add(DeletePost(postId));
  }
}
