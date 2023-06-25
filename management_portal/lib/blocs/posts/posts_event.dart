// Define the events
abstract class PostEvent {}

class FetchPosts extends PostEvent {}

class DeletePost extends PostEvent {
  final int postId;

  DeletePost(this.postId);
}
