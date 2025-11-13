import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SlidingListTiles()));
}

class SlidingListTiles extends StatefulWidget {
  const SlidingListTiles({super.key});

  @override
  _SlidingListTilesState createState() => _SlidingListTilesState();
}

class _SlidingListTilesState extends State<SlidingListTiles> {
  bool _showTiles = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sliding List Tiles')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(_showTiles ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _showTiles = !_showTiles;
                  });
                },
              ),
            ),
            Divider(),

            // Animated content
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: _showTiles ? null : 0,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text('Account Settings'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.notifications, color: Colors.orange),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.security, color: Colors.green),
                      title: Text('Privacy & Security'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.help, color: Colors.purple),
                      title: Text('Help & Support'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
