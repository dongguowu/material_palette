import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'NavigationErrorRoute')
class NavigationErrorPage extends StatelessWidget {
  final String errorMessage;

  const NavigationErrorPage({
    super.key,
    this.errorMessage = "An unknown error occurred.",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back
                },
                child: Text('Go Back'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement retry logic or navigate to a specific page
                  Navigator.of(context).pushNamed('/home'); // Example route
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
