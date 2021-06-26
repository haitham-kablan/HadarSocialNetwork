import 'package:flutter/material.dart';

showError(BuildContext context,String errMsg,IconData icon) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(right: 25.0),
        height: 70,
        color: Colors.black87,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.red,
            ),
            Text(
              '  ' + errMsg,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    },
  );
}