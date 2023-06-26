abstract class CommentsEvent {}

class FetchComments extends CommentsEvent {
  final int postId;

  FetchComments(this.postId);
}
