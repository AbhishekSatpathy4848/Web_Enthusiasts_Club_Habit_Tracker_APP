import 'dart:io';

import 'package:dio/dio.dart' hide Response;
import 'package:functions_framework/functions_framework.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:habit_tracker_app_dart_cloud_functions/constants.dart';
import 'package:habit_tracker_app_dart_cloud_functions/network_client.dart';
import 'package:habit_tracker_app_dart_cloud_functions/credentials.dart';
import 'package:shelf/shelf.dart';
import 'package:sprintf/sprintf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  NetworkClient.init();
  String quote = await getDailyQuote();
  await sendPushNotificationToTopic("motivationalquotes", quote);

  return Response(HttpStatus.accepted, body: quote);
}

Future<String> getDailyQuote() async {
  final response = await NetworkClient.client.getUri(
      Uri.https(
          QUOTE_API_DOMAIN, QUOTE_API_ENDPOINT, QUERY_PARAMS),
      options: Options(headers: QUOTE_HEADERS));
  return (response.data as List)[0]["quote"];
}

Future sendPushNotificationToTopic(String topicName, String message) async {
  final messageJSON = {
    "message": {
      "topic": topicName,
      "notification": {
        "title": "Motivational Daily Quote",
        "body": message,
      }
    }
  };

  final serviceAccountCredentials = getServiceAccountCredentials();

  AuthClient client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccountCredentials), scopeList);

  await NetworkClient.client.postUri(
      Uri.https(FCM_PUSH_NOTIFICATION_DOMAIN,
          sprintf(FCM_PUSH_NOTIFICATION_ENDPOINT, [PROJECT_ID])),
      options: Options(headers: {
        "Authorization": "Bearer ${client.credentials.accessToken.data}"
      }),
      data: messageJSON);

  print("Sent Notification successfully");
  return Future.value();
}
