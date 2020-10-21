// ProfileApp

import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/ui/profile/edit_profile.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class ProfileApp extends StatefulWidget {
  @override
  _ProfileAppState createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  PostStore _postStore;
  UserStore _userStore;
  @override
  void didChangeDependencies() {
    _postStore = Provider.of<PostStore>(context);
    _userStore = Provider.of<UserStore>(context);
    if (!_postStore.loading) _postStore.getPosts();
    if (!_userStore.loading) _userStore.getUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
            // Observer(builder: (context) {return
            //   _userStore.user != null ?
            //    Text(
            //     _userStore.user.name,
            //     style: TextStyle(color: Colors.black),
            //   ):Text("no");
            // }),
      
      body: LayoutBuilder(
        builder: (BuildContext buildcontext, BoxConstraints boxconstraints) {
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(3),
                    width: boxconstraints.maxWidth / 4,
                    height: boxconstraints.maxHeight/ 6,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]),
                        shape: BoxShape.circle),
                    child: ClipOval(
                        child: Image.network(
                      "https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/advice/maps-satellite-images/satellite-image-of-globe.jpg",
                      fit: BoxFit.cover,
                    )),
                  ),
                   
                  Observer(builder: (context) {return
                   _postStore.postList != null ?
                   follower(text: "پستها", number:_postStore.postList.posts.length.toString())
                  :
                  Text("no") ;

                  },)
                 
                ],
              ),
              SizedBox(
                height: 10,
              ),
               const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 1,
            indent: 20,
            endIndent: 30,
            
          ),

              Row(children: [
                editwidget(
                    text: "editprofile",
                    onTap: () {
                        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => editprofile()),
  );
                    }),
              ]),
              SizedBox(
                height: 10,
              ),
              
              Observer(builder: (context) {
                return _postStore.postList != null ?  _postwidget(posts: _postStore.postList.posts)
                :Text("no");
              },)
            
            ],
          );
        },
      ),
    );
  }
}
 class _postwidget extends StatelessWidget {
  final List<Post> posts;

  const _postwidget({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(padding: EdgeInsets.only(left: 25,right: 25),
        crossAxisCount: 3,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 1,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: List.generate(posts.length, (index) {
          return Image.network(
       "https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/advice/maps-satellite-images/satellite-image-of-globe.jpg",

            // posts[index].images[0].path,
            fit: BoxFit.cover,
          );
        })
        );
  }
}

class editwidget extends StatelessWidget {
  final String text;
  final Function onTap;
  const editwidget({Key key, this.text, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
          height: 45,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5, left: 25, right: 25, top: 0),
          decoration: BoxDecoration(
            color: Colors.blue[900],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          )),
    ));
  }
}

class follower extends StatelessWidget {
  final String number;
  final String text;
  const follower({Key key, this.number, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(text),
        Padding(
          padding: EdgeInsets.only(left: 10,right: 20,),
          child: Text(number),
        )
      ],
    ));
  }
}
