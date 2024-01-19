// ignore_for_file: use_build_context_synchronously, must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:imagescanner/screens/crop_painter.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CropImage extends StatefulWidget {
  File file;
  int index;
  Function? updateIndexData;
  CropImage(this.index, this.file, this.updateIndexData, {super.key});
  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  final GlobalKey key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late double width, height;
  late Size imagePixelSize;
  bool isFile = false;
  late Offset tl, tr, bl, br;
  bool isLoading = false;
  MethodChannel channel = const MethodChannel('opencv');
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), getImageSize);
  }

  void getImageSize() {
    RenderBox imageBox = key.currentContext!.findRenderObject() as RenderBox;
    width = imageBox.size.width;
    height = imageBox.size.height;
    final ImageInput inputFile = FileInput(widget.file);
    imagePixelSize = ImageSizeGetter.getSize(inputFile);
    tl = const Offset(20, 20);
    tr = Offset(width - 20, 20);
    bl = Offset(20, height - 20);
    br = Offset(width - 20, height - 20);
    setState(() {
      isFile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crop Image'),
          actions: const [
            // TextButton(onPressed: () {}, child: const Text('B & W')),
          ],
        ),
        backgroundColor: ThemeData.dark().canvasColor,
        key: _scaffoldKey,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onPanDown: (details) {
                      double x1 = details.localPosition.dx;
                      double y1 = details.localPosition.dy;
                      double x2 = tl.dx;
                      double y2 = tl.dy;
                      double x3 = tr.dx;
                      double y3 = tr.dy;
                      double x4 = bl.dx;
                      double y4 = bl.dy;
                      double x5 = br.dx;
                      double y5 = br.dy;
                      if (sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= 0 &&
                          x1 < width / 2 &&
                          y1 < height / 2) {
                        print(details.localPosition);
                        setState(() {
                          tl = details.localPosition;
                        });
                      } else if (sqrt((x3 - x1) * (x3 - x1) +
                                  (y3 - y1) * (y3 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= 0 &&
                          x1 < width &&
                          y1 < height / 2) {
                        setState(() {
                          tr = details.localPosition;
                        });
                      } else if (sqrt((x4 - x1) * (x4 - x1) +
                                  (y4 - y1) * (y4 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= height / 2 &&
                          x1 < width / 2 &&
                          y1 < height) {
                        setState(() {
                          bl = details.localPosition;
                        });
                      } else if (sqrt((x5 - x1) * (x5 - x1) +
                                  (y5 - y1) * (y5 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= height / 2 &&
                          x1 < width &&
                          y1 < height) {
                        setState(() {
                          br = details.localPosition;
                        });
                      }
                    },
                    onPanUpdate: (details) {
                      double x1 = details.localPosition.dx;
                      double y1 = details.localPosition.dy;
                      double x2 = tl.dx;
                      double y2 = tl.dy;
                      double x3 = tr.dx;
                      double y3 = tr.dy;
                      double x4 = bl.dx;
                      double y4 = bl.dy;
                      double x5 = br.dx;
                      double y5 = br.dy;
                      if (sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= 0 &&
                          x1 < width / 2 &&
                          y1 < height / 2) {
                        print(details.localPosition);
                        setState(() {
                          tl = details.localPosition;
                        });
                      } else if (sqrt((x3 - x1) * (x3 - x1) +
                                  (y3 - y1) * (y3 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= 0 &&
                          x1 < width &&
                          y1 < height / 2) {
                        setState(() {
                          tr = details.localPosition;
                        });
                      } else if (sqrt((x4 - x1) * (x4 - x1) +
                                  (y4 - y1) * (y4 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= height / 2 &&
                          x1 < width / 2 &&
                          y1 < height) {
                        setState(() {
                          bl = details.localPosition;
                        });
                      } else if (sqrt((x5 - x1) * (x5 - x1) +
                                  (y5 - y1) * (y5 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= height / 2 &&
                          x1 < width &&
                          y1 < height) {
                        setState(() {
                          br = details.localPosition;
                        });
                      }
                    },
                    child: SafeArea(
                      child: Container(
                        color: ThemeData.dark().canvasColor,
                        constraints: const BoxConstraints(maxHeight: 450),
                        child: Image.file(
                          widget.file,
                          key: key,
                        ),
                      ),
                    ),
                  ),
                  isFile
                      ? SafeArea(
                          child: CustomPaint(
                            painter: CropPainter(tl, tr, bl, br),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              bottomSheet()
            ],
          ),
        ));
  }

  Widget bottomSheet() {
    return Container(
      color: ThemeData.dark().canvasColor,
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // ElevatedButton(
                //   onPressed: () {},
                //   child: const Text(
                //     "Retake",
                //     style: TextStyle(color: Colors.black, fontSize: 18),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 140,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 60.0,
                            height: 20.0,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                            ),
                          )
                        : isFile
                            ? ElevatedButton(
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  double tl_x =
                                      (imagePixelSize.width / width) * tl.dx;
                                  double tr_x =
                                      (imagePixelSize.width / width) * tr.dx;
                                  double bl_x =
                                      (imagePixelSize.width / width) * bl.dx;
                                  double br_x =
                                      (imagePixelSize.width / width) * br.dx;

                                  double tl_y =
                                      (imagePixelSize.height / height) * tl.dy;
                                  double tr_y =
                                      (imagePixelSize.height / height) * tr.dy;
                                  double bl_y =
                                      (imagePixelSize.height / height) * bl.dy;
                                  double br_y =
                                      (imagePixelSize.height / height) * br.dy;
                                  Map<String, double> cropPoints = {
                                    'tl_x': tl_x,
                                    'tl_y': tl_y,
                                    'tr_x': tr_x,
                                    'tr_y': tr_y,
                                    'bl_x': bl_x,
                                    'bl_y': bl_y,
                                    'br_x': br_x,
                                    'br_y': br_y,
                                  };
                                  int cropWidth = (tr_x - tl_x).toInt();
                                  int cropHeight = (bl_y - tl_y).toInt();

                                  img.Image? imageFile =
                                      await _getImageFromPath(widget.file.path);

                                  img.Image croppedImage = img.copyCrop(
                                      imageFile!,
                                      x: tl_y.toInt(),
                                      y: tl_y.toInt(),
                                      width: cropWidth,
                                      height: cropHeight);

                                  File? croppedImageData =
                                      await saveImageAsFile(croppedImage);

                                  widget.updateIndexData!(
                                      widget.index, croppedImageData);

                                  Navigator.pop(context);
                                },
                              )
                            : const SizedBox(
                                width: 60,
                                height: 20.0,
                                child: Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ))),
                              ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<img.Image?> _getImageFromPath(String path) async {
    // Read the image file
    List<int> imageBytes = await File(path).readAsBytes();

    // Decode the image
    img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

    return decodedImage;
  }

  Future<File?> saveImageAsFile(img.Image image) async {
    // Convert image to bytes
    List<int> pngBytes = img.encodePng(image);

    Directory? imagePath = await getApplicationSupportDirectory();
    String imageName =
        "${imagePath.path.toString()} ${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg";

    // Create a File instance
    File file = File(imageName);

    // Write the bytes to the file
    return await file.writeAsBytes(Uint8List.fromList(pngBytes));
  }

  // Future<dynamic> convertToGray() async {
  //   // Invoke the method to convert the image to grayscale
  //   var bytesArray = await channel.invokeMethod('convertToGray', {
  //     'filePath': widget.file.path,
  //     'tl_x': tl_x,
  //     'tl_y': tl_y,
  //     'tr_x': tr_x,
  //     'tr_y': tr_y,
  //     'bl_x': bl_x,
  //     'bl_y': bl_y,
  //     'br_x': br_x,
  //     'br_y': br_y,
  //   });

  //   // Update the state with the converted image bytes
  //   setState(() {
  //     bytes = bytesArray;
  //     whiteboardBytes = bytesArray;
  //   });

  //   return bytesArray;
  // }

  // Future<void> grayAndOriginal() async {
  //   // Delay for 1 second before invoking the image processing methods
  //   Future.delayed(const Duration(seconds: 1), () {
  //     // Invoke the methods for grayscale, whiteboard, and original
  //     channel.invokeMethod('gray', {
  //       'filePath': widget.file.path,
  //       'tl_x': tl_x,
  //       'tl_y': tl_y,
  //       'tr_x': tr_x,
  //       'tr_y': tr_y,
  //       'bl_x': bl_x,
  //       'bl_y': bl_y,
  //       'br_x': br_x,
  //       'br_y': br_y,
  //     });
  //     channel.invokeMethod('whiteboard', {
  //       'filePath': widget.file.path,
  //       'tl_x': tl_x,
  //       'tl_y': tl_y,
  //       'tr_x': tr_x,
  //       'tr_y': tr_y,
  //       'bl_x': bl_x,
  //       'bl_y': bl_y,
  //       'br_x': br_x,
  //       'br_y': br_y,
  //     });
  //     channel.invokeMethod('original', {
  //       'filePath': widget.file.path,
  //       'tl_x': tl_x,
  //       'tl_y': tl_y,
  //       'tr_x': tr_x,
  //       'tr_y': tr_y,
  //       'bl_x': bl_x,
  //       'bl_y': bl_y,
  //       'br_x': br_x,
  //       'br_y': br_y,
  //     });
  //   });

  //   // Wait for 7 seconds before checking the completion of image processing
  //   Timer(Duration(seconds: 7), () {
  //     // Handle the completion of image processing methods
  //     channel.invokeMethod('grayCompleted').then((value) {
  //       grayBytes = value;
  //       isGrayBytes = true;
  //     });

  //     channel.invokeMethod('whiteboardCompleted').then((value) {
  //       whiteboardBytes = value;
  //       isWhiteBoardBytes = true;
  //     });

  //     channel.invokeMethod('originalCompleted').then((value) {
  //       originalBytes = value;
  //       isOriginalBytes = true;

  //       // If the bottom sheet is open, close it and show a new one
  //       if (isBottomOpened) {
  //         Navigator.pop(context);
  //         BottomSheet bottomSheet = BottomSheet(
  //           onClosing: () {},
  //           builder: (context) => colorBottomSheet(),
  //           enableDrag: true,
  //         );
  //         controller = scaffoldKey.currentState
  //             .showBottomSheet((context) => bottomSheet);
  //       }
  //     });
  //   });
  // }
}
