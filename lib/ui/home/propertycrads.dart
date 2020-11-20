import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/post/post.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class PropertyCrads extends StatefulWidget {
  PropertyCrads({this.postsList});
  final PostList postsList;
  @override
  _PropertyCradsState createState() => _PropertyCradsState();
}

class _PropertyCradsState extends State<PropertyCrads>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------

  var initialIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
          child: Material(
            child: _buildListView(),
          ),
        ),
        // _navbarsection(),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: widget.postsList.posts.length,
      itemBuilder: (context, position) {
        return _buildListItem(widget.postsList.posts, position);
      },
    );
  }

  // retun (_postStore.postList != null && _postStore.postList.posts.length > 0)
  //     ? ListView.builder(
  //         itemCount: _postStore.postList.posts.length,
  //         itemBuilder: (context, position) {
  //           return _buildListItem(position);
  //         },
  //       )
  //     : Center(
  //         child: Text(
  //           AppLocalizations.of(context).translate('home_tv_no_post_found'),
  //         ),
  //       );
  // }

  Widget _buildListItem(List<Post> posts, int position) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration(milliseconds: 0), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.post, (Route<dynamic> route) => false);
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                      post: widget.postsList.posts[position],
                    )),
          );
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.black,
          elevation: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      trailing: Icon(Icons.more_vert),
                      dense: false,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      title: Text(
                        '${posts[position].category.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.blue),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.greenAccent,
                              ),
                              Text(
                                '${posts[position].district.city.name},${posts[position].district.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ],
                          ),
                          posts[position].category.name.contains('رهن')
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.greenAccent,
                                    ),
                                    Text(
                                      'رهن: ${posts[position].deopsit} , اجاره: ${posts[position].rent}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.greenAccent,
                                    ),
                                    Text(
                                      'قیمت: ${posts[position].price}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    width: 130,
                    height: 100,
                    child: posts[position].images.length > 0
                        ? Image.network(
                            Endpoints.baseUrl +
                                "/" +
                                posts[position].images[0]?.path,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/images/a.png", fit: BoxFit.cover),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await appComponent
                                    .getRepository()
                                    .removeFavorite(posts[position]);
                                setState(() {
                                  appComponent
                                      .getRepository()
                                      .getFavoritesList();
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                            Icon(
                              Icons.share,
                              color: Colors.blue[200],
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("متراژ"),
                          Text(
                            '${posts[position].area}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("اتاق خواب"),
                          Text(
                            '${posts[position].bedroom}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("شناسه آگهی"),
                          Text(
                            '${posts[position].id}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.postsList.posts.length == 0) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset("assets/images/404.png"),
//         ],
//       );
//     } else {
//       return SingleChildScrollView(
//         child: Column(
//             children:
//                 List<Widget>.generate(widget.postsList.posts.length, (index) {
//           var url = 'assets/images/a.png';
//           if (widget.postsList.posts[index].images.length > 0) {
//             url = Endpoints.baseUrl +
//                 "/" +
//                 widget.postsList.posts[index].images[0]?.path;
//           }

//           return houseWidget(
//             widget.postsList.posts[index],
//             url,
//           );
//         })),
//       );
//     }
//   }

//   Widget houseWidget(
//     Post post,
//     String imageurl,
//   ) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => PostScreen(
//                       post: post,
//                     )),
//           );
//         },
//         child: Padding(
//           padding: EdgeInsets.only(top: 10, bottom: 5),
//           child: Container(color: Colors.red,
//             height: 310,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6.0)),
//               elevation: 4.0,
//               child: Column(
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Container(
//                         alignment: Alignment.bottomLeft,
//                         color: Colors.amber,
//                         height: 200,
//                         width: 200,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(6),
//                             topRight: Radius.circular(6),
//                           ),
//                           child: imageurl.contains(Endpoints.baseUrl)
//                               ? Image.network(
//                                   imageurl,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.asset(
//                                   imageurl,
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 8.0,
//                         right: 6.0,
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(3.0)),
//                           child: Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Text(
//                                   post.category.name,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 8.0,
//                         left: 6.0,
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(3.0)),
//                           child: Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: Text(
//                               post.district.city.name +
//                                   " " +
//                                   post.district.name,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xff1089ff),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 10, left: 12),
//                     child: !post.category.name.contains('رهن')
//                         ? Container(
//                             width: MediaQuery.of(context).size.width - 50,
//                             child: Text(
//                               post.price.toString(),
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           )
//                         : Container(
//                             width: MediaQuery.of(context).size.width - 50,
//                             child: Text(
//                               'رهن: ${post.deopsit} دلار -  اجاره: ${post.rent} دلار ',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                           ),
//                   ),
//                   SizedBox(height: 7.0),
//                   Container(
//                       width: MediaQuery.of(context).size.width - 20,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Column(
//                             children: <Widget>[
//                               FaIcon(Icons.king_bed),
//                               SizedBox(width: 10),
//                               Text(
//                                 post.bedroom.toString(),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                               // Image.asset(
//                               //   no1Url,
//                               //   fit: BoxFit.contain,
//                               //   height: 30.0,
//                               //   width: 30.0,
//                               // ),
//                             ],
//                           ),
//                           Column(
//                             children: <Widget>[
//                               FaIcon(Icons.square_foot),
//                               SizedBox(width: 10),
//                               Text(
//                                 post.area.toString() + " " + 'متر مربع',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: <Widget>[
//                               FaIcon(Icons.access_alarm_outlined),
//                               SizedBox(width: 10),
//                               Text(
//                                 post.age.toString() == '0'
//                                     ? 'N/A'
//                                     : post.age.toString(),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
