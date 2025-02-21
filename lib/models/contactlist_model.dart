//Model to retrive contact information from server
class Get_contact_model {
  int? pid;
  String? pname;
  String? pphone;

  Get_contact_model({this.pid, this.pname, this.pphone});

  Get_contact_model.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    pname = json['pname'];
    pphone = json['pphone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pid'] = pid;
    data['pname'] = pname;
    data['pphone'] = pphone;
    return data;
  }
}

//Model to add contact to the server
class AddContactModel {
  String? ufullname;
  String? uphonename;

  AddContactModel({this.ufullname, this.uphonename});
}

//Model for editing contact
class EditContactModel {
  String? cname;
  String? cnum;
  String? cid;

  EditContactModel({
    this.cname,
    this.cnum,
    this.cid,
  });
}

// Model for deleting a contact
class DeleteContactModel {
  String? cid;

  DeleteContactModel({this.cid});
}
