import 'package:bestapp/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:bestapp/DioClient.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  List<dynamic> channelList = [];
  @override
  void initState() {
    _fetchChannels();
    super.initState();
  }

  Future<void> _fetchChannels() async {
    List<dynamic>? data = await _client.fetchAllChannels();
    if (data != null) {
      setState(() {
        channelList = data;
      });
    }
  }

  final DioClient _client = DioClient();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: channelList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: channelList[index]["imagetemplate"] != null
                ? Image.network(
                    channelList[index]["imagetemplate"],
                    width: 50,
                    height: 50,
                  )
                : Image.asset(
                    '/Users/josefinhellgren/Downloads/tumblr_c10f588e82fd7136d6837dc3f27e1ff6_7ca0f44e_1280.jpg',
                    width: 50,
                    height: 50,
                  ),
            title: Text(
              channelList[index]["name"],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_circle_right,
              color: Colors.white,
            ),
            onTap: () {
              int channelId =
                  int.tryParse(channelList[index]["id"].toString()) ?? 0;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            channelId: channelId,
                            channelName: channelList[index]["name"],
                          )));
            },
          );
        });
  }
}
