import 'package:flutter/material.dart';
import 'package:trafficcamerasottawa_new/screen/camera.dart';
import 'package:trafficcamerasottawa_new/camera_list.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List foundCameras = [];

  @override
  void initState() {
    foundCameras = cameraList;
    super.initState();
  }

  void getPage(camraId, caeraName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraScreen(cameraId: camraId, cameraName: caeraName),
      ),
    );
  }

  void runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = cameraList;
    } else {
      results = cameraList
          .where((camera) => camera["name"]
              .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
              .toLowerCase()
              .contains(enteredKeyword
                  .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
                  .toLowerCase()))
          .toList();
    }

    setState(() {
      foundCameras = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                floatingLabelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: foundCameras.isNotEmpty
                  ? ListView.builder(
                      itemCount: foundCameras.length,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            getPage(foundCameras[index]["camera_number"],
                                foundCameras[index]["name"]);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          foundCameras[index]["name"],
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
                          )),
                    )
                  : const Text(
                      'No results found!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
