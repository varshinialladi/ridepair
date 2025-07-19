import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Create the HTML div and register the view
      final html.Element mapElement = html.DivElement()
        ..id = 'map-canvas'
        ..style.width = '100%'
        ..style.height = '100%';

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'map-canvas',
        (int viewId) => mapElement,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeMap();
      });
    }
  }

  void _initializeMap() {
    if (js.context['google'] != null && js.context['google']['maps'] != null) {
      final mapOptions = js.JsObject.jsify({
        'center': js.JsObject.jsify({'lat': 37.7749, 'lng': -122.4194}),
        'zoom': 12,
      });

      final mapDiv = html.document.getElementById('map-canvas');
      js.JsObject(js.context['google']['maps']['Map'], [mapDiv, mapOptions]);
    } else {
      print("Google Maps JS not loaded yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Page")),
      body: Center(
        child: kIsWeb
            ? const SizedBox(
                width: 600,
                height: 400,
                child: HtmlElementView(viewType: 'map-canvas'),
              )
            : const Text("Map is only available on Web."),
      ),
    );
  }
}
