import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

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
  Marker point = Marker();
  Position position;

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
    // final dynamic args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: _mapSection(),
    );
  }

  void _getPosition() async {
    final Position position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 14);
  }

  Widget _mapSection() {
    return Stack(children: <Widget>[
      Observer(builder: (context) {
        var center = LatLng(34.52, 69.100);
        if (widget.formState.latitude != null) {
          point = Marker(
              builder: (ctx) => new Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
              width: 80,
              height: 80,
              point: LatLng(
                  widget.formState.latitude, widget.formState.longitude));
          center =
              LatLng(widget.formState.latitude, widget.formState.longitude);
        }
        return FlutterMap(
          mapController: _mapController,
          options: new MapOptions(
            center: center,
            onTap: (point) {
              _generateMarker(point);
            },
            zoom: 15,
            boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(markers: [point])
          ],
        );
      }),
      Positioned(
          right: 0,
          bottom: 55,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: new FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _getPosition();
              },
              child: Icon(
                Icons.gps_fixed,
                color: Colors.black,
              ),
            ),
          )),
      Positioned(
        bottom: 13,
        right: 10,
        left: 10,
        child: Container(
          height: 47,
          width: MediaQuery.of(context).size.width - 20,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () {
              if (widget.formState.latitude != null &&
                  widget.formState.longitude != null) {
                Navigator.pop(context);
              }
            },
            color: Colors.green,
            textColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('location_submit'),
                ),
                Icon(Icons.check),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  void _generateMarker(LatLng coordinations) {
    setState(() {
      point = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(coordinations.latitude, coordinations.longitude),
        builder: (ctx) => new Container(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    });

    widget.formState.setLatitude(coordinations.latitude);
    widget.formState.setLongitude(coordinations.longitude);
  }
}
