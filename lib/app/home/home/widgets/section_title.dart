
import 'package:flutter/material.dart';


Widget sectionTitle(String title, {VoidCallback? onSeeAll, bool showSeeAll = true}) {
  return Row(
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const Spacer(),
      if(showSeeAll)
        InkWell(
          onTap: onSeeAll, // ✅ just pass the callback
          child: const Text(
            'See All',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      if(!showSeeAll)
        SizedBox()
    ],
  );
}