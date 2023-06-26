import 'package:management_portal/models/comment.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;

  CommentsLoaded(this.comments);
}

class CommentsError extends CommentsState {
  final String errorMessage;

  CommentsError(this.errorMessage);
}
