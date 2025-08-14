import 'package:flutter/material.dart';

class ConsistentTopInfo extends StatelessWidget {
  final String userName;
  const ConsistentTopInfo({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "App Name",
            style: TextStyle(fontFamily: "serif", fontSize: 21),
          ),
          const Spacer(),
          Text(
            userName,
            style: const TextStyle(fontFamily: "serif", fontSize: 21),
          ),
          SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(17)),
          )
        ],
      ),
    );
  }
}
