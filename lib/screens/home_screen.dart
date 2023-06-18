import 'package:blogapp60211/screens/add_blog.dart';
import 'package:blogapp60211/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('Blogs');
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("All Blogs"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBlogScreen(),
                      ));
                },
                child: Icon(Icons.add)),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
                onTap: () {
                  _auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  });
                  toastMessage("Logout Successfully");
                },
                child: Icon(Icons.logout)),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search with blog title',
                label: Text("Search"),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder()),
            onChanged: (String value) {
              setState(() {
                search = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: FirebaseAnimatedList(
          query: dbRef.child('Blog List'),
          itemBuilder: (context, snapshot, animation, index) {
            String temptitle = snapshot.child('bTitle').value.toString();
            if (searchController.text.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * .25,
                            placeholder: 'assets/place.png',
                            image: snapshot.child('bImage').value.toString()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.child('bTitle').value.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.child('bDescription').value.toString(),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            } else if (temptitle
                .toLowerCase()
                .contains(searchController.text.toString())) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * .25,
                            placeholder: 'assets/place.png',
                            image: snapshot.child('bImage').value.toString()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.child('bTitle').value.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.child('bDescription').value.toString(),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ))
      ]),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
