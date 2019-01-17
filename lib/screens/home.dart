import 'package:device_finder/api.dart';
import 'package:device_finder/data/models/device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  HomePageState({this.currentUser});

  getCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
    void initState() {
      super.initState();
      this.getCurrentUser();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devices'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FBApi.signOutWithGoogle();
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('device').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final list = snapshot.map((data) => _buildListItem(context, data)).toList();
    final staggeredTiles = list.map((data) => StaggeredTile.fit(1)).toList();
    return StaggeredGridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.only(top: 20.0),
      children: list, 
      staggeredTiles: staggeredTiles,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Device.fromSnapshot(data);
    return InkWell(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network("https://www.sprint.com/content/dam/sprint/commerce/devices/apple/apple_iphone_6s_plus/gray/new/iPhone6sPlus-SpaceGray-463x407-4.jpg"),
            Text(record.name),
            Divider(),
            ListTile(
              title: Text(record.ownedBy(currentUser.uid)),
              leading: Icon(
                Icons.donut_small,
                color: record.donutColor(currentUser.uid),
              ),
            ),
          ]
        ),
      ),
      onTap: () => Firestore.instance.runTransaction((trans) async{
        final freshSnapshot = await trans.get(record.reference);
        final fresh = Device.fromSnapshot(freshSnapshot);
        await trans.update(
          record.reference, 
          { 
            'is_available': !fresh.isAvailable, 
            'user':  {
              'id': currentUser.uid,
              'name': currentUser.displayName,
              'img_url': currentUser.photoUrl
            }
          }
        );
      }),
    ) ;
  }
}