import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class UserMapScreen extends StatefulWidget {
  UserMapScreen({Key key, this.formState}) : super(key: key);

  // final String title;
  final PostFormStore formState;
  @override
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  //text controllers:-----------------------------------------------------------
  MapController _mapController = MapController();
  double longitude = 0;
  double latitude = 0;
  Position position;

  @override
  void initState() {
    super.initState();
    _getPosition().then((value) {
      position = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final dynamic args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      primary: true,
      appBar: _buildAppBar(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          height: 47,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('location_submit'),
                ),
                Icon(Icons.send),
              ],
            ),
          ),
        ),
      ),
      body: _mapSection(),
    );
  }

  Future<Position> _getPosition() async {
    final Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('map')),
    );
  }

  Widget _mapSection() {
    return Stack(children: <Widget>[
      FlutterMap(
        mapController: _mapController,
        options: new MapOptions(
          // center: new LatLng(widget.formState.latitude ?? 0,
          //     widget.formState.longitude ?? 0),
          onTap: (point) {
            setState(() {
              latitude = point.latitude;
              longitude = point.longitude;
            });
            widget.formState.setLatitude(position.latitude);
            widget.formState.setLongitude(position.longitude);
          },
          zoom: 14,
          // bounds: LatLngBounds(LatLng(58.8, 6.1), LatLng(59, 6.2)),
          boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              _generateMarker(),
              // new Marker(
              //   width: 80.0,
              //   height: 80.0,
              //   point: LatLng(
              //     widget.formState.latitude,
              //     widget.formState.longitude,
              //   ),
              //   builder: (ctx) => new Container(
              //     child: Icon(
              //       Icons.location_on,
              //       color: Colors.red,
              //       size: 40,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: new FloatingActionButton(
              onPressed: () {
                setState(() {
                  latitude = position.latitude;
                  longitude = position.longitude;
                });
                widget.formState.setLatitude(position.latitude);
                widget.formState.setLongitude(position.longitude);
                _mapController.move(LatLng(latitude, longitude), 14);
              },
              child: Icon(Icons.gps_fixed),
            ),
          )),
    ]);
  }

  Marker _generateMarker() {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(
        latitude ?? 0,
        longitude ?? 0,
      ),
      builder: (ctx) => new Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
  }
}
