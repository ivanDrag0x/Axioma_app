import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axioma Maps',
      home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

// Metodo para obtener la ubicación del dispositivo
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    Location location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null!;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  int seleccion = 1;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //Titulo Superior
      appBar: AppBar(
        title: Text('Axioma Maps'),
      ),

      //Barra lateral- Navigation Drawer
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            //Items del Drawer
            ListTile(
              title: Text('Inicio'),
              leading: Icon(Icons.home),
              onTap: () {},
            ),
            ListTile(
              title: Text('Favoritos'),
              leading: Icon(Icons.star),
              onTap: () {},
            ),
            ListTile(
              title: Text('Ubicaciones Guardadas'),
              leading: Icon(Icons.save),
              onTap: () {},
            ),
            ListTile(
              title: Text('Mi Cuenta'),
              leading: Icon(Icons.account_balance),
              onTap: () {},
            ),
            ListTile(
              title: Text('Configuración'),
              leading: Icon(Icons.settings),
              onTap: () {},
            )
          ],
        ),
      ),

      //Barra inferior- BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        //Funcion para cambiar la opcion seleccionada
        onTap: (index) {
          setState(() {
            seleccion = index;
          });
        },
        currentIndex: seleccion,

        //Items de la barra inferior
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: 'Usuario'),
          BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: 'Ruta'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),

      //Cuerpo del Google Maps
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

        //Para habilitar la localización del dispositivo
        myLocationEnabled: true,
      ),

      //Boton que dirige al usuario a la ubicación actual
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _currentLocation,
        label: Text('Home'),
        icon: Icon(Icons.location_on),
      ),

      //Para localizar el boton un poco arriba en el centro
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
