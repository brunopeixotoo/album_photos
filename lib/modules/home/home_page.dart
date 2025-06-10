import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/core.dart';
import '../../core/network/api_service.dart';
import 'repositories/home_repositories.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _search = TextEditingController();
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    final homeRepository = HomeRepository(apiClient.client);
    _controller = HomeController(homeRepository);
    _controller.loadPhotos();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                suffixIcon: Watch<Widget>((context) {
                  if (_controller.searchText.value.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _search.clear();
                        _controller.clearSearch();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _controller.updateSearchText,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Watch<Widget>((context) {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredPhotos = _controller.filteredPhotos;
                
                if (filteredPhotos.isEmpty) {
                  return const Center(child: Text('Nenhuma foto encontrada.'));
                }

                return ListView.separated(
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
                          child: const Icon(Icons.photo, color: Colors.white),
                        ),
                        title: Text(
                          photo['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text('ID: ${photo['id'] ?? ''}'),
                        onTap: () {
                          Modular.to.pushNamed(
                            Routes.details + Routes.detailsPhoto,
                            arguments: {
                              'photoId': photo['id'],
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
