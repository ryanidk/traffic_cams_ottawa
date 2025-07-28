import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {super.key, required this.cameraId, required this.cameraName});
  final cameraId;
  final cameraName;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  void updateData() {
    setState(() {});
  }

  Future<void> addToFavorites(Map favorite) async {
    var box = Hive.box<Map>('favourites');
    await box.add(favorite);
  }

  Future<void> removeFromFavorites(int index) async {
    var box = Hive.box<Map>('favourites');
    await box.deleteAt(index);
  }

  ValueNotifier<bool> isFavorited = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    checkIfFavorited();
  }

  void checkIfFavorited() {
    var box = Hive.box<Map>('favourites');
    isFavorited.value =
        box.values.any((element) => element['cameraId'] == widget.cameraId);
    setState(() {});
  }

  void toggleFavorite() async {
    var box = Hive.box<Map>('favourites');
    if (isFavorited.value) {
      // Find the camera in the favorites and remove it
      final key = box.keys.firstWhere(
        (k) => box.get(k)?['cameraId'] == widget.cameraId,
        orElse: () => null,
      );
      if (key != null) {
        await box.delete(key);
      }
    } else {
      // Add the camera to favorites
      await box.add({
        "cameraId": widget.cameraId,
        "cameraName": widget.cameraName,
        // Include other necessary fields here
      });
    }
    // Update the favorite status
    isFavorited.value = !isFavorited.value;
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cameraName)),
      body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Image.network(
                'https://traffic.ottawa.ca/beta/camera?id=${widget.cameraId}&timestamp=${DateTime.now().millisecondsSinceEpoch.toString()}',
                width: double.infinity,
                fit: BoxFit.fitWidth),
            const Padding(padding: EdgeInsets.all(6)),
            Text(
              'Last updated: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(top: 24)),
          ]))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: updateData,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: toggleFavorite,
            backgroundColor: Colors.red,
            child: ValueListenableBuilder<bool>(
              valueListenable: isFavorited,
              builder: (context, value, child) {
                return Icon(
                  value ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
