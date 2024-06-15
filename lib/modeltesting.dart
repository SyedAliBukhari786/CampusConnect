import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> getPrediction(String tweet) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/predict'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'tweet': tweet,
    }),
  );

  if (response.statusCode == 200) {
    final prediction = jsonDecode(response.body)['prediction'];
    print('Prediction: $prediction');
  } else {
    throw Exception('Failed to get prediction');
  }
}
