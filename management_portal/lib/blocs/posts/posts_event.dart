// Define the events
abstract class PostEvent {}

class FetchPosts extends PostEvent {}

class GetPostsById extends PostEvent {
  final int postId;

  GetPostsById(this.postId);
}

class AddPost extends PostEvent {
  final Map<String, dynamic> post;

  AddPost(this.post);
}

class DeletePost extends PostEvent {
  final int postId;

  DeletePost(this.postId);
}
