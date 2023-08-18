import 'package:flutter/material.dart';
import 'Editprofile.dart';
import 'loginpage.dart';

class profilepg extends StatefulWidget {
  const profilepg({Key? key}) : super(key: key);

  @override
  State<profilepg> createState() => _profilepgState();
}

class _profilepgState extends State<profilepg> {
  String _name = "admin"; // Declare _name here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.blueGrey,
        title: Text('Profile'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          Text(
            _name, // Use _name here
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            onTap: () async {
              Map<String, dynamic>? updatedProfile = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    currentName: _name, // Pass the current name here
                  ),
                ),
              );

              if (updatedProfile != null) {
                setState(() {
                  // Update the profile details if they were changed
                  _name = updatedProfile['name'];
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
