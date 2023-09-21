import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/functions/firebaseFunctions.dart';

class Home extends StatefulWidget {
  Home({ Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  String currentStudentName = ''; // Initialize with empty string
  String currentStudentEmail = ''; // Initialize with empty string
  String currentStudentPhoneNumber = ''; // Initialize with empty string
  int currentStudentAge = 0;

//refactore
  void _showEditDialog(BuildContext context, String uid,String name, String email, String phoneNumber, int age) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedName = name; // Initialize with current data
        String updatedEmail = email; // Initialize with current data
        String updatedPhoneNumber = phoneNumber; // Initialize with current data
        int updatedAge =age; // Initialize with current data
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: currentStudentName , // Initialize with current data
                  decoration: InputDecoration(labelText: 'Full Name'),
                  onChanged: (value) {
                    updatedName = value;
                  },
                ),
                TextFormField(
                  initialValue: currentStudentEmail, // Initialize with current data
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    updatedEmail = value;
                  },
                ),
                TextFormField(
                  initialValue:  currentStudentPhoneNumber, // Initialize with current data
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    updatedPhoneNumber = value;
                  },
                ),
                TextFormField(
                  initialValue: updatedAge.toString(), // Initialize with current data
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedAge = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Update the user's information in Firestore using FirestoreServices
                FirestoreServices.updateUser(uid, {
                  'name': updatedName,
                  'email': updatedEmail,
                  'phoneNumber': updatedPhoneNumber,
                  'age': updatedAge,
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

//end dialog box



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
        title: const Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No students found.');
          }
          // Extract student data and display it in a ListView.
          final students = snapshot.data!.docs;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final studentData = students[index].data() as Map<String, dynamic>;
              final studentName = studentData['name'];
              final studentEmail = studentData['email'];
              final studentPhoneNumber = studentData['phoneNumber'];
              final studentAge = studentData['age'];
              final uid = students[index].id;

              return Dismissible(
                key: Key(uid),
                onDismissed: (direction) {
                  // Implement delete functionality here
                  FirestoreServices.deleteUser(uid);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child:   Padding(padding: EdgeInsets.all(12),
                  child: Card(
                    shadowColor: Colors.brown,
                    surfaceTintColor: Colors.orangeAccent,
                    child: ListTile(
                      title: Text(studentName),
                      subtitle: Text('Email: $studentEmail | Age: $studentAge   | Phone: $studentPhoneNumber'),

                      leading: CircleAvatar(
                       // backgroundImage: NetworkImage(studentImageUrl),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            currentStudentName = studentName;
                            currentStudentEmail = studentEmail;
                            currentStudentPhoneNumber = studentPhoneNumber;
                            currentStudentAge = studentAge;
                          });
                          _showEditDialog(context, uid,studentName, studentEmail, studentPhoneNumber, studentAge);
                        },
                      ),
                    ),
                  ),
                ),//nn mm
              );

            },
          );
        },
      ),

    );
  }
}


