import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trafficcamerasottawa_new/screen/camera.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Box<Map> favoritesBox;
  void getPage(camraId, caeraName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraScreen(cameraId: camraId, cameraName: caeraName),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box<Map>('favourites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favourites'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ValueListenableBuilder(
            valueListenable: favoritesBox.listenable(),
            builder: (context, Box<Map> box, _) {
              if (box.values.isEmpty) {
                return const Center(
                    child: Text('No favourites yet!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)));
              }

              return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  final camera = box.getAt(index);
                  return InkWell(
                      onTap: () {
                        getPage(camera?["cameraId"], camera?["cameraName"]);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        // or any specific height
                        child: Card(
                          color: const Color.fromARGB(248, 248, 248, 248),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      camera?["cameraName"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.navigate_next,
                                    color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              );
            },
          ),
        ));
  }
}
