import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/DAO/receiptDAO.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
//   final path = (await getExternalStorageDirectory())!.path;
//   final file = File('$path/$fileName');
//   await file.writeAsBytes(bytes, flush: true);
//   // OpenFile.open('$path/$fileName');
//   String timeNow = DateFormat('kk:mm:ss').format(DateTime.now());

//   final ref =
//       FirebaseStorage.instance.ref().child("pdf").child(timeNow + '.pdf');
//   await ref.putFile(file);
//   String urlPDF = await ref.getDownloadURL();
//   print(urlPDF);
//   updatePDFReceipt(urlPDF);
// }

Future<void> saveAndLaunchFileOpen(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
}
