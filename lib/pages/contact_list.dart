import 'package:contact_management_app/models/contactlist_model.dart';
import 'package:contact_management_app/services/contact_services.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isReady = false;
  List<Get_contact_model> _contacts = [];
  final Logger _logger = Logger('HomeScreen');

  // This function is used to fetch and update the contacts from the server
  _getAllContacts() {
    setState(() {
      isReady = true;
    });

    GetContactList().getGet_contact_model().then((value) {
      setState(() {
        _contacts = value ?? [];
        isReady = false;
      });
    }).catchError((error) {
      _logger.severe(error);
      setState(() {
        isReady = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  // Function to handle the swipe-to-refresh behavior
  Future<void> _onRefresh() async {
    await _getAllContacts(); // Reload contacts from server
  }

  int currentIndex = 0;

  void onPageSelect(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/addcontact');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/about');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentIndex == 0 ? 'Contact' : 'About'),
      ),
      body: isReady
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh, // Refreshes the contacts when swiped
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/editcontact',
                        arguments:
                            _contacts[index].pid, // Passing pid to EditContact
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _contacts[index].pname ?? "No Name",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _contacts[index].pphone ?? "No Phone",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const Divider(height: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onPageSelect,
        items: const [
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
