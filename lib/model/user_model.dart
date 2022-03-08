class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? preference;
  String? address;

  //contructor
  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.contactNumber,
      this.preference,
      this.address});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      contactNumber: map['contactNumber'],
      preference: map['preference'],
      address: map['address']
    );
  }

  //sending data from server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'preference': preference,
      'address':address
    };
  }
}
