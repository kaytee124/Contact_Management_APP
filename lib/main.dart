import 'package:contact_management_app/pages/edit_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/about.dart';
import 'pages/add_contact.dart';
import 'pages/contact_list.dart';

void main() {
  runApp(ContactHomepage()); // Run the app and start from the ContactHomepage
}

class ContactHomepage extends StatelessWidget {
  const ContactHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Namer App', // Set the app title
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 design system
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black), // Custom color scheme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              Colors.black, // Set background color of bottom navigation bar
          selectedItemColor: Colors.white, // Color for selected bottom nav item
          unselectedItemColor:
              Colors.grey, // Color for unselected bottom nav items
          showUnselectedLabels:
              false, // Hide unselected labels in the bottom nav
        ),
      ),
      home: const HomeScreen(), // Set the home screen of the app
      initialRoute: '/', // Set initial route to HomeScreen
      routes: {
        '/addcontact': (context) =>
            AddContact(), // Define route for AddContact page
        '/about': (context) => aboutinfo(), // Define route for About page
        '/editcontact': (context) {
          // Define route for EditContact page, passing an argument (pid)
          final int pid = ModalRoute.of(context)!.settings.arguments as int;
          return EditContact(pid: pid); // Pass 'pid' to the EditContact page
        },
      },
    );
  }
}
