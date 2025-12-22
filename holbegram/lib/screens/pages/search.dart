import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 238, 238),
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onFieldSubmitted: (String _) {
            setState(() {});
          },
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
          if (!snapshot.hasData ||
              (snapshot.data! as QuerySnapshot).docs.isEmpty) {
            return const Center(child: Text("No posts found"));
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              var postData = (snapshot.data! as QuerySnapshot).docs[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  postData['postUrl'],
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
