import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.longitude, this.latitude}) : super(key: key);
  final double longitude;
  final double latitude;
  // final String title;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //text controllers:-----------------------------------------------------------

  //stores:---------------------------------------------------------------------

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
      primary: true,
      body: Column(
        children: <Widget>[
          _mapSection(),
        ],
      ),
    );
  }

  Widget _mapSection() {
    return Expanded(
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(widget.latitude, widget.longitude),
          zoom: 16,
          // bounds: LatLngBounds(LatLng(58.8, 6.1), LatLng(59, 6.2)),
          boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(widget.latitude, widget.longitude),
                builder: (ctx) => new Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
