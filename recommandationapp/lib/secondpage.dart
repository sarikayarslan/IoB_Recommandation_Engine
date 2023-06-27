import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class SecondPage extends StatefulWidget {
  final String data;
  final String segment;

  SecondPage({required this.data, required this.segment});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final url = Uri.parse('http://192.168.3.103:5000/');
  int counter = 0;
  var adsResult;

  double startLatitude = 0;
  double startLongitude = 0;
  var targetLatitute;
  var targetLongitute;
  double distance = 0;

  Future callApi() async {
    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var result = adsFromJson(response.body);
        print(result.segment.toString());
        print(result.consequents.length.toString());
        print(result.ansequents[0].toString());
        setState(() {
          adsResult = result;
          counter = result.consequents.length;
        });
        if (mounted) setState(() {});
        return result;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Permission denied');
      // ignore: unused_local_variable
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position.latitude.toString() + ' ' + position.longitude.toString());
      startLatitude = position.latitude;
      startLongitude = position.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController1.text = '40.746';
    _textEditingController2.text = '30.329';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 0,
            ),
            child: Text(
              widget.data as String,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey[1000],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 20,
            ),
            child: Text(
              widget.segment as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 20,
            ),
            child: Text(
              'Campaigns',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.grey[1000],
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: counter != 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: counter,
                      itemBuilder: (context, index) {
                        if (adsResult.segment == widget.segment.toString()) {
                          print('Target place is near you');
                          if (distance < 3000) {
                            return ListTile(
                              title: Text(
                                  adsResult.consequents[index].toString() +
                                      "ALANA"),
                              subtitle: Text(
                                  adsResult.ansequents[index].toString() +
                                      " %20 INDIRIMLI"),
                            );
                          } else {
                            return const Text('Target place is not near you');
                          }
                        }
                        return const Text(
                            'We do not have a suitable campaign for you.');
                      },
                    )
                  : Text('Loading...'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              'For Admin:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(29),
              child: TextField(
                controller: _textEditingController1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Target Market Latitute',
                ),
                keyboardType: TextInputType.number,
              )),
          Padding(
              padding: const EdgeInsets.only(left: 29, right: 29, bottom: 29),
              child: TextField(
                controller: _textEditingController2,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(),
                  border: OutlineInputBorder(),
                  labelText: 'Target Market Longitude',
                ),
                keyboardType: TextInputType.number,
              )),
          Center(
            child: ElevatedButton(
              onPressed: () {
                try {
                  getCurrentPosition();
                  setState(() {
                    targetLatitute = double.parse(_textEditingController1.text);
                    targetLongitute =
                        double.parse(_textEditingController2.text);
                    distance = Geolocator.distanceBetween(startLatitude,
                        startLongitude, targetLatitute, targetLongitute);
                    callApi();
                    //print(distance);
                  });
                } catch (e) {
                  targetLatitute = 0;
                  targetLongitute = 0;
                  print(e.toString());
                }
              },
              child: const Text('Update Target Market'),
            ),
          ),
          Center(
            child: Text(
              'Target Market Latitute: $targetLatitute\nTarget Market Longitude: $targetLongitute\nDistance: $distance meters',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
