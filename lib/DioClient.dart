import 'dart:ffi';

import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();
  final _baseUrl = "http://api.sr.se/api/v2/scheduledepisodes";

  Future<Map<String, dynamic>?> fetchChannelsFromPage(int page) async {
    try {
      Response response = await _dio
          .get("http://api.sr.se/api/v2/channels?format=json&page=${page}");
      Map<String, dynamic> data = response.data;

      final pagination = data["pagination"];
      final totalpages = pagination["totalpages"] as int;

      return {'data': data["channels"], 'totalpages': totalpages};
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>?> fetchAllChannels() async {
    List<Map<String, dynamic>> allChannels = [];
    int page = 1;

    while (true) {
      final response = await fetchChannelsFromPage(page);

      if (response == null) {
        print("is it null?");
        break;
      }

      final totalpages = response['totalpages'] as int;
      final data = response['data'] as List<dynamic>;

      allChannels.addAll([for (var item in data) item as Map<String, dynamic>]);

      if (page >= totalpages) {
        break;
      }

      page++;
    }

    return allChannels;
  }

  Future<Map<String, dynamic>?> fetchDataFromPage(
      int page, int forChannelId) async {
    try {
      Response response = await _dio.get(_baseUrl, queryParameters: {
        'channelid': forChannelId,
        'format': 'json',
        'page': page,
      });
      Map<String, dynamic> data = response.data;
      print(data["schedule"]);
      final pagination = data["pagination"];
      final totalpages = pagination["totalpages"] as int;
      print(totalpages);

      return {'data': data["schedule"], 'totalpages': totalpages};
    } on DioError catch (e) {}
  }

  Future<List<Map<String, dynamic>>?> fetchAllData(int forChannel) async {
    List<Map<String, dynamic>> allData = [];
    int page = 1;

    while (true) {
      final response = await fetchDataFromPage(page, forChannel);

      if (response == null) {
        break;
      }

      final totalpages = response['totalpages'] as int;
      final data = response['data'] as List<dynamic>;

      allData.addAll([for (var item in data) item as Map<String, dynamic>]);

      if (page >= totalpages) {
        break;
      }

      page++;
    }

    return allData;
  }
}
