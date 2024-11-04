import 'package:flutter/material.dart';
import 'package:frontend/create.dart';
import 'package:frontend/delete_data.dart';
import 'package:frontend/display_data.dart';
import 'package:frontend/update_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget _buildButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome to the App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CreateScreen()),
                    ),
                    icon: Icons.create,
                    label: 'CREATE',
                  ),
                  const SizedBox(height: 15),
                  
                  _buildButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DisplayScreen()),
                    ),
                    icon: Icons.read_more_rounded,
                    label: 'READ',
                  ),
                  const SizedBox(height: 15),
                  
                  _buildButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => UpdateScreen()),
                    ),
                    icon: Icons.update,
                    label: 'UPDATE',
                  ),
                  const SizedBox(height: 15),
                  
                  _buildButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DeleteScreen()),
                    ),
                    icon: Icons.delete,
                    label: 'DELETE',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
