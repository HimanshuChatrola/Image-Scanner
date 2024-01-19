// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';
// import 'package:edge_detection/edge_detection.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagescanner/lang/locale_keys.g.dart';
import 'package:imagescanner/screens/grid_items.dart';
import 'package:imagescanner/utils/global.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class TakePhotoScreen extends StatefulWidget {
  File? file;
  int? index;
  TakePhotoScreen(this.file, this.index, {super.key});

  @override
  TakePhotoScreenState createState() => TakePhotoScreenState();
}

class TakePhotoScreenState extends State<TakePhotoScreen> {
  final List<File> images = [];
  late CameraController _controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    if (widget.file != null) {
      File imageFile = File(widget.file!.path);
      setState(() {
        images.add(imageFile);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorAquamarin,
        title: const Text(
          LocaleKeys.appTitle,
          style: TextStyle(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      body: Column(
        children: [
          // List view for view the images
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GridItem(
                    image: images[index],
                    index: index,
                    onDelete: () {
                      setState(() => images.removeAt(index));
                    },
                    onDoubleTap: _updateList,
                  );
                }),
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: images.isNotEmpty,
            replacement: const SizedBox(
              height: 20,
            ),
            child: ElevatedButton(
              onPressed: () {
                generatePdfFromImages(images);
              },
              child: const Text(
                LocaleKeys.createPDF,
                style: TextStyle(color: AppColors.colorGrey),
              ),
            ),
          ),
        ],
      ),
      //Capture image button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorAquamarin,
        onPressed: () {
          _pickImage(ImageSource.camera);
        },
        tooltip: LocaleKeys.pickImage,
        child: const Icon(Icons.add_a_photo, color: AppColors.colorWhite),
      ),
    );
  }

  // Function to open camera and get path of image.
  Future<void> _pickImage(ImageSource source) async {
    final permission = Permission.camera;
    if (await permission.isGranted) {
      Directory? imagePath = await getApplicationSupportDirectory();
      String imageName =
          "${imagePath.path.toString()} ${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg";
      await EdgeDetection.detectEdge(
        imageName,
        androidCropTitle: LocaleKeys.crop,
        androidCropBlackWhiteTitle: LocaleKeys.blackAndWhite,
        androidCropReset: LocaleKeys.reset,
      );
      // availableCameras().then((List<CameraDescription> cameras) {
      //   if (cameras.isNotEmpty) {
      //     setState(() {
      //       this.cameras = cameras;
      //       _controller =
      //           CameraController(cameras[1], ResolutionPreset.ultraHigh);
      //       _controller.initialize().then((_) async {
      //         if (!mounted) {
      //           return;
      //         }
      //       });
      //     });
      //   }
      // });
      setState(() {
        if (imagePath.existsSync()) {
          images.add(File(imageName));
        }
      });
    } else {
      await permission.request();
    }
  }

  // Funaction to convert images to PDF file.
  Future<void> generatePdfFromImages(List<File> imageFiles) async {
    final pdf = pw.Document();

    for (final imageFile in imageFiles) {
      Uint8List uint8list = File(imageFile.path).readAsBytesSync();
      pdf.addPage(pw.Page(
        build: (context) =>
            pw.Image(pw.MemoryImage(uint8list), fit: pw.BoxFit.contain),
      ));
    }

    //Get storage access to store the PDF file.
    final output = await getDownloadsDirectory();

    // File name and path to store the file.
    final file = File("${output!.path}/output.pdf");

    //Save the PDF that we have created.
    await file.writeAsBytes(await pdf.save());

    // Open PDF file after generate.
    await OpenFile.open(file.path);
  }

  void _updateList(int index, File image) async {
    print(index);
    setState(() {
      images[index] = image;
    });
  }
}
