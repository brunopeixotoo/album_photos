import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo/core/network/api_service.dart';
import 'package:photo/data/repositories/details/photo_details/photo_details_repositories.dart';
import '../../../../core/core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailsPhoto extends StatefulWidget {
  const DetailsPhoto({super.key});

  @override
  State<DetailsPhoto> createState() => _DetailsPhotoState();
}
class _DetailsPhotoState extends State<DetailsPhoto> {
  int currentPageIndex = 0;
  Map<String, dynamic> user = {};
  List<dynamic> comment = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDetailsAndComments();
  }
  
  // Fetch phot details and comments when the page is initialized
  void getDetailsAndComments() async {
    final apiClient = ApiClient();
    final photoDetailsRepositories = PhotoDetailsRepositories(apiClient.client);

    final args = Modular.args.data as Map?;
    final int? id = args?['photoId'] as int?;

    if (id != null) {
      setState(() => isLoading = true);
      try {
        final details = await photoDetailsRepositories.getPhotoDetails(id);
        final comments = await photoDetailsRepositories.getPhotoComments(id);
        setState(() {
          user = details;
          comment = comments;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  // Build the UI for the photo details page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Photo Details', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) async {
          setState(() {
            currentPageIndex = index;
          });
          if (index == 0) {
            // final lat = user['address']?['geo']?['lat'];
            // final lng = user['address']?['geo']?['lng'];
            // if (lat != null && lng != null) {
            //   final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
            //   if (await canLaunchUrl(url)) {
            //     if (!mounted) return;
            //     await launchUrl(url, mode: LaunchMode.externalApplication);
            //   } else {
            //     if (!mounted) return;
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Não foi possível abrir o Maps')),
            //     );
            //   }
            // } else {
            //   if (!mounted) return;
            // }
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
            Modular.to.pushNamed(Routes.details + Routes.commentsPhoto);
          }
        },

        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: currentPageIndex,
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
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                              user.isNotEmpty
                                  ? user['name'] ?? 'User Name'
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
                              user.isNotEmpty
                                  ? user['email'] ?? 'User Email'
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.isNotEmpty
                                  ? user['company']['name'] ?? 'Company name'
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.isNotEmpty
                                  ? user['company']['catchPhrase'] ?? 'Company name'
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
                itemCount: comment.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final c = comment[index];
                  if (c == null || c.isEmpty) {
                    return Text(
                      'No comments available.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])
                    );
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor,
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
      ),
    );
  }
}