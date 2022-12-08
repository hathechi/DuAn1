import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app_fluter/PDF/mobile.dart';
import 'package:my_app_fluter/modal/receipt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tiengviet/tiengviet.dart';

PdfGrid getGrid(Receipt receipt) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 16));
  //Secify the columns count to the grid.
  grid.columns.add(count: 4);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];

  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.black;

  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[0].value = 'Name';
  headerRow.cells[1].value = 'Price';
  headerRow.cells[2].value = 'Quantity';
  headerRow.cells[3].value = 'Total';
  //Add rows
  double tongtienchuagiamgia = 0;
  for (int i = 0; i < receipt.listCart!.length; i++) {
    tongtienchuagiamgia += receipt.listCart![i].tongtien!;
    addProducts(
        productName: receipt.listCart![i].tensp!,
        price: receipt.listCart![i].giasp,
        quantity: receipt.listCart![i].slsp,
        total: receipt.listCart![i].tongtien,
        grid: grid);
  }
  log(tongtienchuagiamgia.toString());
  final PdfGridRow row = grid.rows.add();
  final PdfGridRow row1 = grid.rows.add();
  final PdfGridRow row2 = grid.rows.add();
  row.cells[3].value = "\$" + tongtienchuagiamgia.toStringAsFixed(3);
  row1.cells[3].value = "-" + receipt.phantramgiam! + "%";
  row2.cells[3].value = "TOTAL: \$" + receipt.tongtien!.toStringAsFixed(3);

  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable2);
  //Set gird columns width
  grid.columns[0].width = 300;
  grid.columns[1].width = 80;
  grid.columns[2].width = 50;
  grid.columns[3].width = 100;

  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == j) {
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
    {String? productName,
    double? price,
    int? quantity,
    double? total,
    PdfGrid? grid}) {
  final PdfGridRow row = grid!.rows.add();
  row.cells[0].value = TiengViet.parse(productName!);
  row.cells[1].value = "\$" + price.toString();
  row.cells[2].value = quantity.toString();
  row.cells[3].value = "\$" + total.toString();
}

Future<void> printPdf(Receipt receipt) async {
  PdfDocument document = PdfDocument();

  var status = await Permission.storage.status;
  if (status != PermissionStatus.granted) {
    PermissionStatus permissionStatus = await Permission.storage.request();
    status = permissionStatus;
  } else if (status != PermissionStatus.denied) {
    final page = document.pages.add();
    page.graphics.drawString(
      'Shoes Store',
      PdfStandardFont(PdfFontFamily.helvetica, 40, style: PdfFontStyle.bold),
      format: PdfStringFormat(
        lineAlignment: PdfVerticalAlignment.top,
      ),
      brush: PdfBrushes.black,
    );
    page.graphics.drawString(
      'Hoa Don Mua Hang (${receipt.mahoadon} _ ${receipt.ngaytaohd})',
      PdfStandardFont(PdfFontFamily.helvetica, 26),
      format: PdfStringFormat(
        lineAlignment: PdfVerticalAlignment.top,
      ),
      brush: PdfBrushes.red,
      bounds: const Rect.fromLTWH(0, 50, 0, 0),
    );
    page.graphics.drawString('Client: ${receipt.nguoinhan}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
        ),
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(0, 80, 0, 0));
    page.graphics.drawString('PhoneNumber: ${receipt.phoneNumber}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
        ),
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(0, 100, 0, 0));

    final PdfGrid grid = getGrid(receipt);

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 140, 0, 0));
    final List<int> bytes = document.saveSync();
    document.dispose();

    await saveAndLaunchFileOpen(bytes, 'hoadon.pdf');
  }
}
