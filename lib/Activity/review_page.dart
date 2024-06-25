import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:wareg_app/Util/Ip.dart';

class ReviewPage extends StatefulWidget {
  final int userId;

  ReviewPage({required this.userId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<dynamic> reviews = [];
  bool isLoading = true;
  Map<int, int> reviewCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  int? selectedRating;

  @override
  void initState() {
    super.initState();
    fetchReviewCounts();
    selectedRating = null; // Initialize to "semua"
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    String url = '$_baseUrl/transactions/reviews?userId=${widget.userId}';
    if (selectedRating != null) {
      url += '&rating=$selectedRating';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body);
      });
    } else {
      print('Failed to load reviews');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchReviewCounts() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/transactions/review-counts?userId=${widget.userId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        reviewCounts = Map<int, int>.from(
          json
              .decode(response.body)
              .map((key, value) => MapEntry(int.parse(key), value as int)),
        );
      });
    } else {
      print('Failed to load review counts');
    }
  }

  void selectRating(int? rating) {
    setState(() {
      selectedRating = rating;
    });
    fetchReviews();
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => selectRating(null), // Handle "semua" filter
                  child: Column(
                    children: [
                      Text(
                        'Semua',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedRating == null
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                      Text('${reviewCounts.values.reduce((a, b) => a + b)}'),
                    ],
                  ),
                ),
                ...List.generate(5, (index) {
                  int rating = index + 1;
                  return GestureDetector(
                    onTap: () => selectRating(rating),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star,
                          color: selectedRating == rating
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        Text('${reviewCounts[rating]}')
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: SpinKitCircle(color: Colors.green, size: 50.0))
                : reviews.isEmpty
                    ? Center(child: Text('No reviews found.'))
                    : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(review[
                                                'userRecipientProfilePicture']
                                            .toString()
                                            .replaceFirst(
                                                'http://localhost:3000',
                                                '${Ip().getType()}://${Ip().getIp()}')),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(review['userRecipientName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(formatDate(review['createdAt']),
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(review['postTitle'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(review['comment']),
                                  SizedBox(height: 10),
                                  Row(
                                    children: List.generate(review['review'],
                                        (index) {
                                      return Icon(Icons.star,
                                          color: Colors.orange, size: 20);
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
