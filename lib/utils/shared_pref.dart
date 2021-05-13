import 'package:shared_preferences/shared_preferences.dart';

Future setUserId(String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('id', id);
}

Future<String> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('id');
}

Future setPhoneNumber(String phone) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('phone', phone);
}

Future<String> getPhoneNumber() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('phone');
}

Future setName(String name) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('name', name);
}

Future<String> getName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('name');
}

Future setUsername(String username) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('username', username);
}

Future<String> getUsername() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('username');
}

Future setEmail(String email) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('email', email);
}

Future<String> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email');
}

Future setMembershipNumber(String membershipNo) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('membership_no', membershipNo);
}

Future<String> getMembershipNumber() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('membership_no');
}

Future setCategory(String category) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('category', category);
}

Future<String> getCategory() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('category');
}

Future setGender(String gender) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('gender', gender);
}

Future<String> getGender() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('gender');
}

Future setDOB(String dob) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('dob', dob);
}

Future<String> getDOB() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('dob');
}

Future setPostalCode(String postalCode) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('postal_code', postalCode);
}

Future<String> getPostalCode() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('postal_code');
}

Future setTown(String town) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('town', town);
}

Future<String> getTown() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('town');
}

Future setAddress(String address) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('address', address);
}

Future<String> getAddress() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('address');
}

Future setBiography(String biography) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('biography', biography);
}

Future<String> getBiography() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('biography');
}

Future setPracticeSector(String practiceSector) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('practice_sector', practiceSector);
}

Future<String> getPracticeSector() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('practice_sector');
}

Future setBranch(String branch) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('branch', branch);
}

Future<String> getBranch() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('branch');
}

Future setPhoto(String photo) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('photo', photo);
}

Future<String> getPhoto() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('photo');
}

Future setResume(String resume) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('resume', resume);
}

Future<String> getResume() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('resume');
}

Future<void> clearAllPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}
