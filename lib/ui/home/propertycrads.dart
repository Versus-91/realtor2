import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/post/post.dart';
// ignore: unused_import
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/post/editepost.dart';
import 'package:boilerplate/ui/post/post.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:share/share.dart';

class PropertyCrad extends StatefulWidget {
  PropertyCrad({this.post, this.canEdit = false});
  final Post post;
  final bool canEdit;
  final Repository repository = appComponent.getRepository();

  @override
  _PropertyCradState createState() => _PropertyCradState();
}

class _PropertyCradState extends State<PropertyCrad>
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
    return _buildBody();
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: Material(
            child: _buildListItem(widget.post),
          ),
        ),
        // _navbarsection(),
      ],
    );
  }

  // Widget _buildListView() {
  //   return ListView.builder(
  //     itemCount: widget.posts.length,
  //     itemBuilder: (context, position) {
  //       return _buildListItem(widget.posts, position);
  //     },
  //   );
  // }

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

  Widget _buildListItem(Post post) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration(milliseconds: 0), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.post, (Route<dynamic> route) => false);
        });
      },
      child: GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            screen: PostScreen(
              post: post,
            ),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
                      // trailing: Icon(Icons.more_vert),
                      dense: false,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      title: Text(
                        '${post.category.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${post.district.area.city?.name},${post.district.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                        .translate('price') +
                                    ":" +
                                    AppLocalizations.of(context)
                                        .transformCurrency(post.price),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
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
                    padding: EdgeInsets.only(top: 2.0, left: 8),
                    width: 130,
                    height: 100,
                    child: post.images.length > 0
                        ? ProgressiveImage(
                            image: NetworkImage(
                              Endpoints.baseUrl +
                                  "/" +
                                  post.images[0]?.path +
                                  '?height=192&width=192',
                            ),
                            fit: BoxFit.cover,
                            height: 128,
                            width: 128,
                            thumbnail: NetworkImage(
                              Endpoints.baseUrl + "/" + post.images[0]?.path,
                            ),
                            placeholder: AssetImage("assets/images/a.png"),
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
                    const EdgeInsets.only(left: 0.0, right: 10.0, bottom: 5.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Visibility(
                            //   visible: widget.post.favId != null,
                            //   child: GestureDetector(
                            //       onTap: () async {
                            //         print(widget.post.favId.toString());
                            //       },
                            //       child: Icon(
                            //         Icons.delete,
                            //         color: Colors.redAccent,
                            //       )),
                            // ),

                            IconButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.blue[200],
                              ),
                              onPressed: () async {
                                await Share.share(Endpoints.baseUrl +
                                    '/ads/' +
                                    widget.post.id.toString());
                              },
                            ),

                            Visibility(
                              visible: widget.canEdit,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.purple[200],
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context,
                                                {rootNavigator: true}) =>
                                            EditPostScreen(
                                              post: post,
                                            )),
                                  );
                                },
                              ),
                            )

                            // widget.isEdditing == true
                            //     ? Flexible(
                            //         child: IconButton(
                            //           icon: Icon(
                            //             Icons.delete,
                            //             color: Colors.red[200],
                            //           ),
                            //           onPressed: () {},
                            //         ),
                            //       )
                            //     : Container(
                            //         width: 0,
                            //         height: 0,
                            //       ),
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
                          Text(
                            AppLocalizations.of(context).translate('area'),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .transformNumbers(post.area.toString()),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      if (post.bedroom != 0) ...[
                        VerticalDivider(
                          color: Colors.grey,
                          width: 10,
                          endIndent: 4,
                        )
                      ],
                      if (post.bedroom != 0) ...{
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('count_room'),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(1)),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .transformNumbers(post.bedroom.toString()),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      } else ...{
                        SizedBox.shrink()
                      },
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('post_id'),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .transformNumbers(post.id.toString()),
                            style: TextStyle(
                              fontSize: 14,
                            ),
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

  @override
  void dispose() {
    super.dispose();
  }
}

// {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.posts.posts.length == 0) {
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
//                 List<Widget>.generate(widget.posts.posts.length, (index) {
//           var url = 'assets/images/a.png';
//           if (widget.posts.posts[index].images.length > 0) {
//             url = Endpoints.baseUrl +
//                 "/" +
//                 widget.posts.posts[index].images[0]?.path;
//           }

//           return houseWidget(
//             widget.posts.posts[index],
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
