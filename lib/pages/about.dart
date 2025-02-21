import 'package:flutter/material.dart';

// Stateful widget to display the About information screen.
class aboutinfo extends StatefulWidget {
  const aboutinfo({super.key});

  @override
  aboutinfoState createState() => aboutinfoState();
}

// State class to manage the About screen functionality.
class aboutinfoState extends State<aboutinfo> {
  int currentIndex = 2; // Current view page index (About page by default)

  // Function to handle page navigation when a bottom navigation item is tapped.
  void onPageselect(int index) {
    setState(() {
      currentIndex =
          index; // Update the current page index based on user selection
    });

    // Navigate to the respective page based on the selected index.
    if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/addcontact', // Navigate to Add Contact page
      );
    } else if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/', // Navigate to the Contact list page
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentIndex == 0
            ? 'Contact'
            : currentIndex == 1
                ? 'Add Contact'
                : 'About'), // Dynamically update title based on selected page
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Display app version
              Text(
                'Contact Management 1.0',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              // Display developer's name
              Text(
                'Kwame Nkuah Tawiah-88432025',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              // Display app description
              Text(
                'This app allows you to view contacts, add contacts, edit and delete contacts. It first runs into the contact list which displays the list of'
                'contacts. Each contact is a tappable card which sends you to the edit page for you to edit or delete the contact. ',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ]),
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            currentIndex, // Highlight the currently selected page in the bottom nav
        onTap: onPageselect, // Trigger navigation on tap
        items: const [
          // Navigation options
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
