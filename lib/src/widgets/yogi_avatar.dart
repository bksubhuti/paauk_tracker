import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/services/file_exists.dart';
import 'dart:async';

Future<bool> getYogiFileExists(String yogiID) async {
// for a file

  bool bExist = await fileExists('${Prefs.databaseDir}/$yogiID.jpg');
//  await Future.delayed(const Duration(seconds: 2), () {});

  debugPrint("file: $yogiID   exists: $bExist");
  return bExist;
}

class YogiCircleAvatar extends StatelessWidget {
  const YogiCircleAvatar({Key? key, required this.yogiID, this.radius = 60})
      : super(key: key);
  final String yogiID;
  final double radius;

  //     _exists = await getexists(widget.yogiID);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius + 10,
      height: radius + 10,
      child: FutureBuilder<bool>(
          future: getYogiFileExists(yogiID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                if (snapshot.data == true) {
                  debugPrint("loading file: ${Prefs.databaseDir}/$yogiID.jpg");
                  return CircleAvatar(
                    radius: radius,
                    child: ClipOval(
                      child:
                          Image.file(File('${Prefs.databaseDir}/$yogiID.jpg')),
                    ),
                  );
                } else {
                  return CircleAvatar(
                      radius: radius,
                      child: Image.asset('assets/meditation_icon.png'),
                      backgroundColor: Colors.transparent);
                }
              }
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
