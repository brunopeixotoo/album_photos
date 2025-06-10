import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:photo/core/network/api_service.dart';
import 'package:photo/modules/details/modules/photo_details/repositories/photo_details_repositories.dart';
import '../../../../core/core.dart';
import 'package:share_plus/share_plus.dart';
import 'photo_details_controller.dart';

class DetailsPhoto extends StatefulWidget {
  const DetailsPhoto({super.key});

  @override
  State<DetailsPhoto> createState() => _DetailsPhotoState();
}
class _DetailsPhotoState extends State<DetailsPhoto> {
  late final PhotoDetailsController _controller;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    final photoDetailsRepositories = PhotoDetailsRepositories(apiClient.client);
    _controller = PhotoDetailsController(photoDetailsRepositories);
    
    final args = Modular.args.data as Map?;
    final int? id = args?['photoId'] as int?;
    
    if (id != null) {
      _controller.loadPhotoDetails(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) async {
          _controller.updateCurrentPageIndex(index);
          
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Localização não disponível')),
            );
          }
          else if (index == 1) {
            Share.share(
              'https://example.com/photo-details',
              subject: 'Assunto'
            );
          }
          else if (index == 2) {
            Modular.to.pushNamed(
              Routes.details + Routes.commentsPhoto,
              arguments: {
                'photoId': _controller.user.value['id']
              }
            );
          }
        },
        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: _controller.currentPageIndex.value,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'See on map',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.mail)),
            label: 'Email',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.comment)),
            label: 'Add comment',
          ),
        ],
      ),
      body: Watch((context) {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            Assets.imageTeste,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Photo Title',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Description of the photo goes here.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 5,
                              ),
                              const SizedBox(height: 20),
                              Divider(),
                              Text(
                                _controller.user.value.isNotEmpty
                                    ? _controller.user.value['name'] ?? 'User Name'
                                    : 'Loading...',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                  height: 1.4,
                                  color: Color(0xFF181D1A),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _controller.user.value.isNotEmpty
                                    ? _controller.user.value['email'] ?? 'User Email'
                                    : 'Loading...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _controller.user.value.isNotEmpty
                                    ? _controller.user.value['company']['name'] ?? 'Company name'
                                    : 'Loading...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _controller.user.value.isNotEmpty
                                    ? _controller.user.value['company']['catchPhrase'] ?? 'Company name'
                                    : 'Loading...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Comentários',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _controller.comments.value.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final c = _controller.comments.value[index];
                    if (c == null || c.isEmpty) {
                      return Text(
                        'No comments available.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600])
                      );
                    }
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 18,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white
                        ),
                      ),
                      title: Text(
                        c['name'] ?? 'User $index',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        c['body'] ?? 'No comment text available.',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}