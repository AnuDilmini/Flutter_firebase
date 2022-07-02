import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/common/shared_pref.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapViewPage extends StatefulWidget {
  static const routeName = '/map-view-page';

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  LatLng userLocation = new LatLng(0.0, 0.0);
  Set<Marker> _markers = {};
  LocationData _currentPosition;

  void _onMapCreated(GoogleMapController _cntlr) async{
    _controller = _cntlr;
    Location location = new Location();
    _currentPosition = await _location.getLocation();
    userLocation = new LatLng(_currentPosition.latitude, _currentPosition.longitude);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 14),
        ),
      );
      setCurrentLocation();
  }

  setCurrentLocation() {
    if (_markers.isNotEmpty) {
      _markers.clear();

    }
    userLocation = new LatLng(_currentPosition.latitude, _currentPosition.longitude);
        _markers.add(Marker(
          markerId: MarkerId('Home'),
          draggable: true,
          position: LatLng(
              _currentPosition.latitude ?? 0.0, _currentPosition.longitude ?? 0.0),
          onDragEnd: ((newPosition) {

          }),
        ));
    setState(() {
    });
    }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: userLocation.latitude != 0.0 ? IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            saveLocation();
          },
        ): SizedBox(),
        elevation: 1.2,
        centerTitle: false,
        titleSpacing: 15,
        title: Text(
          "Location",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.93,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  GestureDetector(
                    onTap: () {
                      setCurrentLocation();
                    },
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.location_searching_rounded,
                          color: Colors.cyan,
                          size: 15,
                        ),
                        Text(
                          " User Current Location",
                          style: TextStyle(
                              fontSize: 17,
                              color:  Colors.cyan,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: _markers,
                  onTap: (pos) {
                    Marker f = Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(pos.latitude, pos.longitude),
                        onTap: () {});
                    _markers.clear();
                    userLocation = new LatLng(pos.latitude, pos.longitude);
                    setState(() {
                      _markers.add(f);
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  saveLocation();
                },
                child: userLocation.latitude != 0.0 ?Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.058,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    color:  Colors.cyan,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                  child: Text(
                    "Confirm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1),
                  ),
                ): SizedBox(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  saveLocation() async{
    if(userLocation != null){

      await SharedPreferencesClass().saveLocation(lat: userLocation.latitude,
          long: userLocation.longitude);

      Navigator.of(context).pop();
    }


  }
}
