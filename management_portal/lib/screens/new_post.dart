import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_portal/blocs/blocs.dart';
import 'package:management_portal/blocs/posts/posts_states.dart';

class NewPostForm extends StatefulWidget {
  @override
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _body = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Post")),
      body: BlocProvider(
          create: (_) => PostBloc(PostInitial()),
          child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Body'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a body';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _body = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Map<String, dynamic> newPost = {
                          'userId': 1,
                          'id': 0,
                          'title': _title,
                          'body': _body,
                        };

                        BlocProvider.of<PostBloc>(context).addPost(newPost);

                        Navigator.of(context).pop(newPost);
                      }
                    },
                  ),
                ],
              ),
            );
          })),
    );
  }
}
