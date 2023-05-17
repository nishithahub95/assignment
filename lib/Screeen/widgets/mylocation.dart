

import 'package:flutter/material.dart';

class myLocation extends StatelessWidget {
  const myLocation({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on),
        Text(address),
        // Text('Alpha 1,'),
        // Text('Greater noida')
      ],
    );
  }
}