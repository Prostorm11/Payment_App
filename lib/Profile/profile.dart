import 'dart:convert';
import 'package:fee_payment_app/components/consistent_top_info.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> studentData = {};

  @override
  void initState() {
    super.initState();
    // Dummy JSON data
    String dummyJson = '''
    {
      "name": "Nana Ameyaw",
      "profile_image": "https://via.placeholder.com/150",
      "course_of_study": "Computer Science",
      "year_of_study": "Freshman",
      "student_type": "Undergraduate",
      "email": "nana.ameyaw@gmail.com",
      "phone_number": "+233 123 456 789",
      "address": "KNUST Campus, Kumasi, Ghana",
      "parent_guardian_name": "Kwame Ameyaw",
      "emergency_contact": "+233 987 654 321",
      "student_id": "KNUST-23200",
      "department": "Computer Science"
    }
    ''';
    studentData = json.decode(dummyJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            const ConsistentTopInfo(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header with profile image and name
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.blue[800]!, Colors.blue[600]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  studentData['profile_image'] ?? ''),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              studentData['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${studentData['course_of_study'] ?? 'N/A'} - ${studentData['year_of_study'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Details section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(Icons.school, 'Student Type',
                                  studentData['student_type'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.email, 'Email',
                                  studentData['email'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.phone, 'Phone Number',
                                  studentData['phone_number'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.location_on, 'Address',
                                  studentData['address'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.badge, 'Student ID',
                                  studentData['student_id'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.account_balance,
                                  'Department', studentData['department'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.person,
                                  'Parent/Guardian Name',
                                  studentData['parent_guardian_name'] ?? 'N/A'),
                              const Divider(),
                              _buildDetailRow(Icons.contact_phone,
                                  'Emergency Contact',
                                  studentData['emergency_contact'] ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
