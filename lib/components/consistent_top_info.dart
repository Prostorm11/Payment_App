import 'package:flutter/material.dart';

class ConsistentTopInfo extends StatelessWidget {
  final String userName;
  const ConsistentTopInfo({super.key,required this.userName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("App Name",style: TextStyle(fontFamily:"serif",fontSize: 21 ),),
          const Spacer(),
           Text(userName,style: const TextStyle(fontFamily:"serif",fontSize: 21 ),),
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
