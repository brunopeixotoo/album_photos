import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/core.dart';
import '../../core/network/api_service.dart';
import '../../../../data/repositories/home/home_repositories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _search = TextEditingController();
  List<dynamic> photos = [];
  String searchText = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    buscarFotos();
  }

  void buscarFotos() async {
    final apiClient = ApiClient();
    final homeRepository = HomeRepository(apiClient.client);

    try {
      final photosApi = await homeRepository.getPhotos();
      setState(() {
        photos = photosApi;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPhotos = photos.where((photo) {
      final title = (photo['title'] ?? '').toString();
      return title.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Photo Albums',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            TextField(
              controller: _search,
              decoration: InputDecoration(
                labelText: 'Search by title',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _search.clear();
                            searchText = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredPhotos.isEmpty
                      ? const Center(child: Text('Nenhuma foto encontrada.'))
                      : ListView.separated(
                          itemCount: filteredPhotos.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final photo = filteredPhotos[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child:
                                  const Icon(Icons.photo, color: Colors.white),
                              ),
                                title: Text(
                                  photo['title'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text('ID: ${photo['id'] ?? ''}'),
                                onTap: () {
                                  Modular.to.pushNamed(
                                    Routes.details + Routes.detailsPhoto,
                                    arguments: {
                                      'photoId': photo['id'],
                                    }
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
