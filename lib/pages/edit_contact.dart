import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:contact_management_app/models/contactlist_model.dart';
import 'package:contact_management_app/services/contact_services.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class EditContact extends StatefulWidget {
  final int pid; // Receiving the 'pid' (contact ID) from the previous screen

  const EditContact({super.key, required this.pid});

  @override
  EditContactState createState() => EditContactState();
}

class EditContactState extends State<EditContact> {
  bool isReady = false; // Flag to indicate if the contact data is loaded
  late Get_contact_model
      contact; // The contact object to store the fetched contact details

  final _formKey = GlobalKey<FormState>(); // Key for the form validation
  final TextEditingController _nameController =
      TextEditingController(); // Controller for the name field
  final TextEditingController _phoneController =
      TextEditingController(); // Controller for the phone number field
  final EditContactService contactService =
      EditContactService(); // Service to handle contact update
  final DeleteContactService delcontactService =
      DeleteContactService(); // Service to handle contact deletion
  final Logger _logger = Logger('EditContact'); // Logger for error handling

  // Function to fetch the contact details using the provided 'pid'
  _getContact() async {
    setState(() {
      isReady = true; // Set loading state to true while fetching data
    });

    GetContact().getGet_contact(widget.pid).then((value) {
      if (value != null) {
        setState(() {
          contact = value;
          _nameController.text =
              contact.pname ?? ""; // Populate name field with contact name
          _phoneController.text =
              contact.pphone ?? ""; // Populate phone number field
          isReady = false; // Set loading state to false after data is loaded
        });
      } else {
        setState(() {
          isReady = false; // If no data, set loading state to false
        });
      }
    }).catchError((error) {
      _logger.severe(error); // Log error if the contact fetch fails
      setState(() {
        isReady = false; // Set loading state to false in case of error
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getContact(); // Fetch the contact details when the screen is loaded
  }

  int currentIndex =
      1; // Current index for navigation (not used here but can be extended)

  // Function to handle bottom navigation
  void onPageselect(int index) {
    setState(() {
      currentIndex =
          index; // Update the index when a navigation item is selected
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(
          context, '/'); // Navigate to the home screen
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
          context, '/about'); // Navigate to the about page
    }
  }

  // Function to submit the form and update the contact
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, get the values and call the update service
      String cname = _nameController.text.trim();
      String cnum = _phoneController.text.trim();
      String cid = widget.pid.toString();

      var response = await contactService.editcontact(cname, cnum, cid);

      if (response != null && mounted) {
        // If the update was successful, navigate back to the contact list
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (Route<dynamic> route) => false,
        );
      } else if (mounted) {
        // Show an error if the update failed
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Failed to edit contact. Please try again."));
      }
    }
  }

  // Function to delete the contact
  void _deletecontact() async {
    String cid = widget.pid.toString();

    var response = await delcontactService.deletecontact(cid);

    if (response != null && mounted) {
      // If deletion is successful, navigate back to the contact list
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    } else if (mounted) {
      // Show an error if the deletion failed
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Error",
              text: "Failed to delete contact. Please try again."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Contact')), // AppBar with the title
      body: isReady
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Form key for validation
                child: Column(
                  children: [
                    // Text field for name input with validation
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Name should contain only alphabets';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Text field for phone number input with validation
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone number should contain only digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _submitForm, // Submit the form to update contact
                          child: const Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: _deletecontact, // Delete the contact
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
