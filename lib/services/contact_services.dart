import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../models/contactlist_model.dart';

final Logger _logger = Logger('ContactService');

// Class to fetch a list of contacts from the server.
class GetContactList {
  // Fetches the list of contact models from the server.
  Future<List<Get_contact_model>?> getGet_contact_model() async {
    try {
      var url = Uri.parse(
          "https://apps.ashesi.edu.gh/contactmgt/actions/get_all_contact_mob");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Get_contact_model> contacts = jsonResponse
            .map((jsonItem) => Get_contact_model.fromJson(jsonItem))
            .toList();
        return contacts;
      }
    } catch (e) {
      _logger.severe("Error fetching contact list: ${e.toString()}");
    }
    return null;
  }
}

// Class to fetch a single contact's details using the contact ID.
class GetContact {
  // Fetches a specific contact model by its contact ID.
  Future<Get_contact_model?> getGet_contact(int contid) async {
    try {
      var url = Uri.parse(
          "https://apps.ashesi.edu.gh/contactmgt/actions/get_a_contact_mob?contid=$contid");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return Get_contact_model.fromJson(json.decode(response.body));
      }
    } catch (e) {
      _logger.severe("Error fetching contact: ${e.toString()}");
    }
    return null;
  }
}

// Class for adding a new contact to the system.
class AddContactService {
  // Sends a request to add a new contact with the provided name and phone number.
  Future<AddContactModel?> addcontact(
      String ufullname, String uphonename) async {
    try {
      var url = Uri.parse(
          "https://apps.ashesi.edu.gh/contactmgt/actions/add_contact_mob");
      var body = {'ufullname': ufullname, 'uphonename': uphonename};
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        if (response.body.trim() == "success") {
          return AddContactModel(ufullname: ufullname, uphonename: uphonename);
        }

        var jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData['data'] == 'success') {
          return AddContactModel(ufullname: ufullname, uphonename: uphonename);
        }
      }
    } catch (e) {
      _logger.severe("Error adding contact: ${e.toString()}");
    }
    return null;
  }
}

// Class for editing an existing contact's information.
class EditContactService {
  // Updates the contact information based on the provided name, number, and ID.
  Future<EditContactModel?> editcontact(
      String cname, String cnum, String cid) async {
    try {
      var url = Uri.parse(
          "https://apps.ashesi.edu.gh/contactmgt/actions/update_contact");
      var body = {'cname': cname, 'cnum': cnum, 'cid': cid};
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        if (response.body.trim() == "success") {
          return EditContactModel(cname: cname, cnum: cnum, cid: cid);
        }

        var jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData['data'] == 'success') {
          return EditContactModel(cname: cname, cnum: cnum, cid: cid);
        }
      }
    } catch (e) {
      _logger.severe("Error editing contact: ${e.toString()}");
    }
    return null;
  }
}

// Class for deleting a contact from the system.
class DeleteContactService {
  // Sends a request to delete the contact based on its ID.
  Future<DeleteContactModel?> deletecontact(String cid) async {
    try {
      var url = Uri.parse(
          "https://apps.ashesi.edu.gh/contactmgt/actions/delete_contact");
      var body = {'cid': cid};
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) {
          return DeleteContactModel(cid: cid);
        }
      } else {
        _logger.warning("Unexpected status code: ${response.statusCode}");
      }
    } catch (e) {
      _logger.severe("Error deleting contact: ${e.toString()}");
    }
    return null;
  }
}
