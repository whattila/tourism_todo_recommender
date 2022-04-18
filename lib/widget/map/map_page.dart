import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/todo.dart';

const LatLng DEFAULT_LOCATION = LatLng(42.7477863,-71.1699932);
const double PIN_VISIBLE_POSITION = 70;
const double PIN_INVISIBLE_POSITION = -220;

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng todoLatLng;

  @override
  void initState() {
    super.initState();
    setTodoLocation();
  }

  void setTodoLocation() {
    // latitude and longitude cannot be null, we only create the page if they are not
    // ALWAYS check!
    todoLatLng = LatLng(widget.todo.latitude ?? DEFAULT_LOCATION.latitude, widget.todo.longitude ?? DEFAULT_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo location'),
      ),
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: todoLatLng,
                  zoom: 14.4746,
                ),
                markers: _markers,
                onTap: (LatLng loc) {
                  setState(() {
                    pinPillPosition = PIN_INVISIBLE_POSITION;
                  });
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showPinsOnMap();
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: pinPillPosition,
              child: MapBottomPill(todo: widget.todo,)
            ),
          ],
        )
    );
  }

  Future<void> showPinsOnMap() async {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('todoPin'),
        position: todoLatLng,
          onTap: () {
            setState(() {
              pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }
      ));
    });
  }
}

class MapBottomPill extends StatelessWidget{
  const MapBottomPill({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero
              )
            ]
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(todo.shortDescription,
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              )
          ),
          Text(todo.address),
          Text(todo.nature)
        ],
      ),
    );
  }
}