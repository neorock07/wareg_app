import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import '../Activity/search_results_page.dart';

Widget CardSearch(BuildContext context) {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.9,
    child: Card(
      color: Colors.white,
      shadowColor: Colors.white10,
      elevation: 3,
      child: TextFormField(
        controller: _searchController,
        style: TextStyle(
            fontFamily: "Poppins", fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              LucideIcons.search,
              color: Colors.grey,
            ),
            hintText: "Cari",
            hintStyle: TextStyle(fontFamily: "Poppins", fontSize: 15.sp),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(3.dm))),
        onFieldSubmitted: (value) => _onSearch(),
      ),
    ),
  );
}
