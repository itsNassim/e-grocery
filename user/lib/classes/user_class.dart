class User {
  final int ID;
  final String fullName;
  final String email;
  final String phoneNumber;

  User({
    required this.ID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}

List<User> globalUsersList = [
  User(
    ID: 1,
    fullName: 'Ali Khan',
    email: 'ali.khan@example.com',
    phoneNumber: "0123456789",
  ),
  User(
    ID: 2,
    fullName: 'Sara Malik',
    email: 'sara.malik@example.com',
    phoneNumber: "0123456789",
  ),
  User(
    ID: 3,
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: "0123456789",
  ),
];
