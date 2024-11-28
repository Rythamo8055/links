import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link Saver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          primary: Colors.lightBlueAccent,
          secondary: Colors.pinkAccent,
          error: Colors.red,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: LinkSaverHome(),
    );
  }
}

class LinkSaverHome extends StatefulWidget {
  const LinkSaverHome({super.key});

  @override
  _LinkSaverHomeState createState() => _LinkSaverHomeState();
}

class _LinkSaverHomeState extends State<LinkSaverHome> {
  final TextEditingController _searchController = TextEditingController(); // For search
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String _currentView = 'List'; // Default view
  List<Map<String, dynamic>> links = [];

  void _addLink() {
    setState(() {
      links.add({
        'title': _titleController.text,
        'url': _linkController.text,
      });
      _linkController.clear();
      _titleController.clear();
    });
  }

  void _filterLinks(String query) {
    setState(() {
      links = links.where((link) {
        final titleLower = link['title'].toString().toLowerCase();
        final urlLower = link['url'].toString().toLowerCase();
        final queryLower = query.toLowerCase();
        return titleLower.contains(queryLower) || urlLower.contains(queryLower);
      }).toList();
    });
  }

  void _reorderLinks(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = links.removeAt(oldIndex);
      links.insert(newIndex, item);
    });
  }

  Widget _buildLinkList() {
    return Expanded(
      child: ReorderableListView(
        onReorder: _reorderLinks,
        children: links.map((link) {
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              key: ValueKey(link['title']),
              title: Text(link['title']),
              subtitle: Text(link['url']),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLinkGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: links.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 30,
                    offset: const Offset(15, 15),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 30,
                    offset: Offset(-15, -15),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(links[index]['title']),
                subtitle: Text(links[index]['url']),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinkCards() {
    return Expanded(
      child: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 30,
                    offset: const Offset(15, 15),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 30,
                    offset: Offset(-15, -15),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      links[index]['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(links[index]['url']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link Saver'),
        actions: [
          DropdownButton<String>(
            value: _currentView,
            onChanged: (String? newValue) {
              setState(() {
                _currentView = newValue!;
              });
            },
            items: <String>['List', 'Grid', 'Cards']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController, // For search
                decoration: const InputDecoration(hintText: 'Search links...'),
                onChanged: _filterLinks,
              ),
            ),
            Expanded(
              child: (_currentView == 'List' ? _buildLinkList() : (_currentView == 'Grid' ? _buildLinkGrid() : _buildLinkCards())),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _linkController,
                      decoration: const InputDecoration(hintText: 'URL'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addLink,
                    child: const Text('Add Link'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
