import 'package:bestapp/DioClient.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int channelId;
  final String channelName;
  const HomePage({Key? key, required this.channelId, required this.channelName})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> scheduleList = [];

  @override
  void initState() {
    _fetchData(widget.channelId);
    super.initState();
  }

  String convertTimestamp(String timestamp) {
    // Extract the numeric part from the timestamp
    RegExp regExp = RegExp(r"(\d+)");
    RegExpMatch? match = regExp.firstMatch(timestamp);

    if (match != null) {
      int timestampInt = int.parse(match.group(0) ?? '0');

      // Convert to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt);

      // Format the DateTime as a string
      String formattedDate =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

      return formattedDate;
    }

    // Return an empty string or an error message if there's no valid match
    return "Invalid Timestamp";
  }

  Future<void> _fetchData(int channelId) async {
    List<dynamic>? data = await _client.fetchAllData(channelId);
    if (data != null) {
      setState(() {
        scheduleList = data;
      });
    }
  }

  final DioClient _client = DioClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: scheduleList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: scheduleList[index]["imageurltemplate"] != null
                ? Image.network(
                    scheduleList[index]["imageurltemplate"],
                    width: 60,
                    height: 60,
                  )
                : Image.asset(
                    '/Users/josefinhellgren/Downloads/tumblr_c10f588e82fd7136d6837dc3f27e1ff6_7ca0f44e_1280.jpg',
                    width: 60,
                    height: 60,
                  ),
            title: Text(
              scheduleList[index]["title"],
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              convertTimestamp(scheduleList[index]["starttimeutc"]),
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    programName: scheduleList[index]["title"],
                    description:
                        scheduleList[index]["description"] ?? "No Description",
                    imageUrl: scheduleList[index]["imageurltemplate"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String description;
  final String imageUrl;
  final String programName;
  const DetailPage(
      {super.key,
      required this.description,
      required this.imageUrl,
      required this.programName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(programName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30.0),
          Image.network(imageUrl),
          SizedBox(height: 16.0),
          Text(
            description,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
