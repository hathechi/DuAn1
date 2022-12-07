import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app_fluter/PDF/mobile.dart';
import 'package:my_app_fluter/modal/cart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

PdfGrid getGrid(
    List<Cart> listCart, double tongtien, String sdt, String diachi) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 16));
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.black;
  headerRow.cells[0].value = 'ID';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';
  //Add rows
  for (int i = 0; i < listCart.length; i++) {
    addProducts(
        productId: listCart[i].idsanpham,
        productName: listCart[i].tensp,
        price: listCart[i].giasp,
        quantity: listCart[i].slsp,
        total: listCart[i].tongtien,
        grid: grid);
  }
  final PdfGridRow row = grid.rows.add();
  row.cells[4].value = "\$" + tongtien.toStringAsFixed(3);

  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void addProducts(
    {String? productId,
    String? productName,
    double? price,
    int? quantity,
    double? total,
    PdfGrid? grid}) {
  final PdfGridRow row = grid!.rows.add();
  row.cells[0].value = productId ?? "";
  row.cells[1].value = productName ?? "";
  row.cells[2].value = "\$" + price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = "\$" + total.toString();
}

Future<void> printPdf(
    List<Cart> listCart, double tongtien, String sdt, String diachi) async {
  log(listCart.length.toString());
  PdfDocument document = PdfDocument();

  var status = await Permission.storage.status;
  if (status != PermissionStatus.granted) {
    PermissionStatus permissionStatus = await Permission.storage.request();
    status = permissionStatus;
  } else if (status != PermissionStatus.denied) {
    final page = document.pages.add();
    String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());

    page.graphics.drawString(
      'Hoa Don Mua Hang ($dateNow)',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      format: PdfStringFormat(
        lineAlignment: PdfVerticalAlignment.top,
      ),
      brush: PdfBrushes.black,
    );
    final PdfGrid grid = getGrid(listCart, tongtien, sdt, diachi);

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 80, 0, 0));
    final List<int> bytes = document.saveSync();
    document.dispose();

    saveAndLaunchFileOpen(bytes, 'hoadon.pdf');
  }
}
