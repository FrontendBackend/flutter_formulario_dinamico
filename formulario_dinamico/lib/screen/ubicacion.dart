import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Ubicacion extends StatefulWidget {
  const Ubicacion({super.key});

  @override
  State<Ubicacion> createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion>
  with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng? _coordenadas;
  double latitud = 0;
  double longitud = 0;
  String ubicacion = 'Presiona el botón para obtener ubicación';
  bool cargandoUbicacion = false;
  final String mapboxToken =
      'pk.eyJ1IjoidmFsZXJpb3VzIiwiYSI6ImNtYTMxZWk1ZzJ1ZjMyaW13b2R0a21nZTYifQ.2BRxdgXTBSm7IN2VSkwfYg';
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;
  List<Placemark> placemarks = [];

  @override
  void initState() {
    super.initState();
    obtenerUbicacion();

    _animController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: -30.0,
      end: 0.0,
    ).chain(CurveTween(curve: Curves.bounceOut)).animate(_animController);

    _animController.forward(); // Inicia la animación
    // _actualizarTextoUbicacion(_coordenadas!);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> obtenerUbicacion() async {
    bool servicioActivo;
    geo.LocationPermission permiso;

    setState(() {
      cargandoUbicacion = true;
    });

    // Verificar si el servicio está activo
    servicioActivo = await geo.Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      setState(() {
        ubicacion = 'El servicio de ubicación está desactivado.';
      });
      return;
    }

    // Verificar permisos
    permiso = await geo.Geolocator.checkPermission();
    if (permiso == geo.LocationPermission.denied) {
      permiso = await geo.Geolocator.requestPermission();
      if (permiso == geo.LocationPermission.denied) {
        setState(() {
          ubicacion = 'Permisos de ubicación denegados';
        });
        return;
      }
    }

    if (permiso == geo.LocationPermission.deniedForever) {
      setState(() {
        ubicacion = 'Permisos denegados permanentemente.';
      });
      return;
    }

    // Obtener la posición
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    // Usar geocoding para obtener la dirección
    placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _coordenadas = LatLng(position.latitude, position.longitude);
        _actualizarTextoUbicacion(_coordenadas!, place);
        // latitud = position.latitude;
        // longitud = position.longitude;
        // ubicacion = 'Latitud: ${position.latitude}, Longitud: ${position.longitude}, Ciudad: ${place.locality}';
        cargandoUbicacion = false;
      }
      // abrirGoogleMaps(position.latitude, position.longitude);
    });

    // Mover el mapa a la nueva ubicación
    _mapController.move(_coordenadas!, 18);
  }

  // Función que aun no se ha usado
  Future<void> abrirGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir Google Maps.';
    }
  }

  void _moverMarcador(LatLng latlng) {
    setState(() {
      cargandoUbicacion = true;
      _coordenadas = latlng;
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _actualizarTextoUbicacion(latlng, place);
      }
    });
    _animController.reset();
    _animController.forward();
  }

  void _actualizarTextoUbicacion(LatLng latlng, Placemark place) {
    ubicacion =
        'Latitud: ${latlng.latitude.toStringAsFixed(7)}, Longitud: ${latlng.longitude.toStringAsFixed(7)}, Ciudad: ${place.locality}';
    cargandoUbicacion = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ubicación Actual')),
      body: crearMapa(),
      floatingActionButton: FloatingActionButton(
        onPressed: obtenerUbicacion,
        child: Icon(Icons.location_on),
      ),
    );
  }

  Column crearMapa() {
    return Column(
      children: [
        if (cargandoUbicacion) LinearProgressIndicator(),
        Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text(ubicacion, style: TextStyle(fontSize: 16))),
        ),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _coordenadas ??
                  LatLng(-12.0464, -77.0428), //Coordenada de Lima por defecto
              initialZoom: 18,
              onTap: (tapPosition, latlng) => _moverMarcador(latlng),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                    // 'https://api.mapbox.com/styles/v1/valerious/cma31jwd3000101s7eg6wb72k/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken',
                additionalOptions: {'accessToken': mapboxToken},
              ),
              if (_coordenadas != null)
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      point: _coordenadas!,
                      width: 40,
                      height: 40,
                      child: AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(-5, _bounceAnimation.value -30),
                            child: Icon(
                              Icons.location_pin,
                              size: 50,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Column crearMapa() {
  //   return Column(
  //     children: [
  //       if (cargandoUbicacion) LinearProgressIndicator(),
  //       Padding(
  //         padding: EdgeInsets.all(16),
  //         child: Center(child: Text(ubicacion)),
  //       ),
  //       Expanded(
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             FlutterMap(
  //               mapController: _mapController,
  //               options: MapOptions(
  //                 initialCenter: _coordenadas ?? LatLng(-12.0464, -77.0428),
  //                 initialZoom: 18,
  //                 onPositionChanged: (position, hasGesture) {
  //                   if (hasGesture) {
  //                     final center = position.center;
  //                     setState(() {
  //                       _coordenadas = center;
  //                       ubicacion =
  //                           'Lat: ${center.latitude}, Lng: ${center.longitude}';
  //                     });
  //                   }
  //                 },
  //               ),
  //               children: [
  //                 TileLayer(
  //                   urlTemplate:
  //                       'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
  //                   additionalOptions: {'accessToken': mapboxToken},
  //                   userAgentPackageName: 'com.tuempresa.tuapp',
  //                 ),
  //               ],
  //             ),
  //             // El marcador fijo en el centro
  //             Icon(Icons.location_pin, size: 50, color: Colors.red),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
