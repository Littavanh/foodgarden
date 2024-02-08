import 'package:flutter/material.dart';
import 'package:foodgarden/style/color.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRImage extends StatelessWidget {
  QRImage(this.shopCode, this.result, {super.key});
  int result;
  String shopCode;
  var text;
  @override
  Widget build(BuildContext context) {
    result == 0 ? text = "$shopCode" : text = "$shopCode$result";

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
        centerTitle: true,
      ),
      // V222222U20172
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomPaint(
            //   size: Size.square(300),
            //   painter: QrPainter(
            //       data: text,
            //       version: QrVersions.auto,
            //       gapless: false,
            //       embeddedImage: Image.asset('assets/images/foodgarden v2.png').image,
            //       embeddedImageStyle: QrEmbeddedImageStyle(size: Size(45, 45))),
            // ),
            // QrImage(
            //   data: text,
            //   version: QrVersions.auto,
            //   size: 300,
            //   gapless: false,
            //   embeddedImage: AssetImage('assets/images/foodgarden v2.png'),
            //   embeddedImageStyle: QrEmbeddedImageStyle(
            //     size: const Size(45, 45),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrettyQrView.data(
                errorCorrectLevel: QrErrorCorrectLevel.H,
                data: text,
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                      image: AssetImage('assets/images/foodgarden v2.png'),
                      position: PrettyQrDecorationImagePosition.embedded),
                  shape: PrettyQrSmoothSymbol(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
