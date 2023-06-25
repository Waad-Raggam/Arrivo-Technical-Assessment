import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_portal/blocs/blocs.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';
import 'package:management_portal/posts_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PostBloc(PostInitial()),
        child: PostTable(),
      ),
    );
  }
}
