// Define the events
abstract class PostEvent {}

class FetchPosts extends PostEvent {}

class GetPostsById extends PostEvent {
  final int postId;

  GetPostsById(this.postId);
}

class DeletePost extends PostEvent {
  final int postId;

  DeletePost(this.postId);
}
