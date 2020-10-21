import 'package:boilerplate/stores/user/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  UserStore _userStore;
  @override
  void didChangeDependencies() {
    _userStore = Provider.of<UserStore>(context);
    if(!_userStore.loading)_userStore.getUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text("editprofile",style: TextStyle(color: Colors.grey[700]),),
      ),
      body: LayoutBuilder(
        builder: (BuildContext buildcontext, BoxConstraints boxconstraints) {
          return ListView(padding: EdgeInsets.only(left: 25,right: 25),
            children: [Column(children: [
 Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(3),
                width: boxconstraints.maxWidth / 3,
                height: boxconstraints.maxHeight / 5,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]),
                    shape: BoxShape.circle),
                child: ClipOval(
                    child: Image.network(
                  "https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/advice/maps-satellite-images/satellite-image-of-globe.jpg",
                  fit: BoxFit.cover,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Observer(builder: (context) {
                return _userStore.user != null
                    ? Text(
                        _userStore.user.name,
                        style: TextStyle(color: Colors.black),
                      )
                    : Text("no");
              }),
            ],),
             
              SizedBox(
                height: 10,
              ),
Column(mainAxisAlignment: MainAxisAlignment.center,
  children: [ 
  
Container(height: 60,padding: EdgeInsets.only(top: 10,),
  child:   TextField(
    obscureText: true,
  
  
    decoration: InputDecoration(  
  
      border: OutlineInputBorder(),
  
      labelText: 'شماره',
  
    ),
  
  ),
),

            
Container(height: 60,padding: EdgeInsets.only(top: 10,),
  child:   TextField(
  
    obscureText: true,
  
    decoration: InputDecoration( fillColor: Colors.grey,
              focusColor: Colors.grey,
  
      border: OutlineInputBorder(),
  
      labelText: 'شماره',
  
    ),
  
  ),
),
Container(height: 60,padding: EdgeInsets.only(top: 10,),
  child:   TextField(
  
    obscureText: true,
  
    decoration: InputDecoration(
  
      border: OutlineInputBorder(),
  
      labelText: 'شماره',
  
    ),
  
  ),
),
Container(height: 60,padding: EdgeInsets.only(top: 10,),
  child:   TextField(
  
    obscureText: true,
  
    decoration: InputDecoration(
  
      border: OutlineInputBorder(),
  
      labelText: 'شماره',
  
    ),
  
  ),
),



],)



            ],
          );
        },
      ),
    );
  }
}
