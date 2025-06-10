import 'package:flutter/material.dart';
import 'package:photo/modules/details/modules/comments/controller/comments_controller.dart';
import 'package:photo/modules/details/modules/comments/repositories/comments_repositories.dart';
import 'package:photo/core/network/api_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CommentsPhoto extends StatefulWidget {
  const CommentsPhoto({super.key});

  @override
  State<CommentsPhoto> createState() => _CommentsPhotoState();
}

class _CommentsPhotoState extends State<CommentsPhoto> {
  late final CommentsController _controller;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    final commentsRepository = CommentsRepositories(apiClient.client);
    _controller = CommentsController(commentsRepository);

    final args = Modular.args.data as Map<String, dynamic>;
    final photoId = args['photoId'] as int;
    _controller.setPhotoId(photoId);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveComment();
    if (!mounted) return;

    if (success) {
      _showSnackBar('Comment saved!');
      _controller.clearForm();
    } else {
      _showSnackBar('Write a title and comment!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Comment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Add your comment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Watch((context) => TextFormField(
                        onChanged: _controller.updateTitle,
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.title),
                        ),
                      )),
                      const SizedBox(height: 16),
                      Watch((context) => TextFormField(
                        onChanged: _controller.updateComment,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Comment",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.comment),
                        ),
                      )),
                      const SizedBox(height: 24),
                      Watch((context) => ElevatedButton.icon(
                        onPressed: _controller.isLoading.value
                            ? null
                            : _handleSave,
                        icon: _controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _controller.isLoading.value ? 'Saving...' : 'Save',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}