
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/functions/firebaseFunctions.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String? currentUserUID;

  String currentStudentName = ''; // Initialize with empty string
  String currentStudentEmail = ''; // Initialize with empty string
  String currentStudentPhoneNumber = ''; // Initialize with empty string
  int currentStudentAge = 0;

  @override
  void initState() {
    super.initState();
    // Get the current user's UID
    // currentUserUID = FirebaseAuth.instance.currentUser?.uid;
  }

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
              onPressed: ()  {
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
//end dialog

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when no user is logged in.
      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Text('No user logged in.'),
        ),
      );
    } else {
      final currentUserUID = currentUser.uid;
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                //await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.notification_add),
            ),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded),
            )
          ],
          title: const Text('Home'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserUID)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('No user data found.');
            }

            // Extract user data and display it.
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final studentName = userData['name'];
            final studentEmail = userData['email'];
            final studentPhoneNumber = userData['phoneNumber'];
            final studentAge = userData['age'];

            return Dismissible(
              key: Key(currentUserUID),
              onDismissed: (direction) {
                // Implement delete functionality here
                FirestoreServices.deleteUser(currentUserUID);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Card(
                  // surfaceTintColor: Colors.orangeAccent,
                  child: ListTile(
                    title: Text(studentName),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       // Text('Email: $studentEmail | Age: $studentAge | Phone: $studentPhoneNumber'),
                        Text('Age: ${studentAge}',style: TextStyle(fontSize: 15,color: Colors.black),),
                        Text('Phone: ${studentPhoneNumber}',style: TextStyle(fontSize: 15,color: Colors.black)),
                        Text('Email: ${studentEmail}',style: TextStyle(fontSize: 15,color: Colors.black)),
                      ],
                    ),
                    leading: CircleAvatar(),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          currentStudentName = studentName;
                          currentStudentEmail = studentEmail;
                          currentStudentPhoneNumber = studentPhoneNumber;
                          currentStudentAge = studentAge;
                        });
                        _showEditDialog(
                          context,
                          currentUserUID,
                          studentName,
                          studentEmail,
                          studentPhoneNumber,
                          studentAge,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );

            //padd hhhhh
          },
        ),
      );
    }
  }
}
