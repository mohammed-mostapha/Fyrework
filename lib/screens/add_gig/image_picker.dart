import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Image_picker extends StatefulWidget {
  @override
  _Image_pickerState createState() => _Image_pickerState();
}

class _Image_pickerState extends State<Image_picker> {
  // PickedFile imageFile;
  File imageFilePreview1;
  File imageFilePreview2;
  File imageFilePreview3;
  File imageFilePreview4;
  File imageFilePreview5;
  File imageFilePreview6;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _camera1());
  }

  // Future _camera() async {
  //   PickedFile theImage = await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //   );

  //   if (theImage != null) {
  //     setState(() {
  //       imageFile = theImage;
  //       print('image: $imageFile');
  //     });
  //   }
  // }

  Future _camera1() async {
    PickedFile pickedFile1 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile1 = File(pickedFile1.path);
    String imagePath1 = pickedFile1.path;
    print('$imagePath1');
    this.setState(() {
      imageFilePreview1 = imageFile1;
    });
  }

  Future _camera2() async {
    PickedFile pickedFile2 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile2 = File(pickedFile2.path);
    this.setState(() {
      imageFilePreview2 = imageFile2;
    });
  }

  Future _camera3() async {
    PickedFile pickedFile3 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile3 = File(pickedFile3.path);
    this.setState(() {
      imageFilePreview3 = imageFile3;
    });
  }

  Future _camera4() async {
    PickedFile pickedFile4 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile4 = File(pickedFile4.path);
    this.setState(() {
      imageFilePreview4 = imageFile4;
    });
  }

  Future _camera5() async {
    PickedFile pickedFile5 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile5 = File(pickedFile5.path);
    this.setState(() {
      imageFilePreview5 = imageFile5;
    });
  }

  Future _camera6() async {
    PickedFile pickedFile6 =
        await ImagePicker().getImage(source: ImageSource.camera);
    File imageFile6 = File(pickedFile6.path);
    this.setState(() {
      imageFilePreview6 = imageFile6;
    });

    // var imageFile = File(await ImagePicker()
    //     .getImage(source: ImageSource.camera)
    //     .then((PickedFile) => PickedFile.path));
    // imageFilePreview = imageFile;
    // print('image: $imageFilePreview');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              GestureDetector(
                onTap: _camera1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview1 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview1,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _camera2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview2 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview2,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _camera3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview3 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview3,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _camera4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview4 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview4,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _camera5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview5 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview5,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _camera6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(100, 50, 50, 50),
                  ),
                  child: imageFilePreview6 == null
                      ? Icon(
                          FontAwesomeIcons.plus,
                          color: FyreworkrColors.white,
                        )
                      : Image.file(
                          imageFilePreview6,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
