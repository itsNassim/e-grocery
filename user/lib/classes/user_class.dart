class User {
  final String fullName;
  final String email;
  final String phoneNumber;

  User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}

List<User> globalUsersList = [
  User(
    fullName: 'Ali Khan',
    email: 'ali.khan@example.com',
    phoneNumber: "0123456789",
  ),
  User(
    fullName: 'Sara Malik',
    email: 'sara.malik@example.com',
    phoneNumber: "0123456789",
  ),
  User(
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: "0123456789",
  ),
];
