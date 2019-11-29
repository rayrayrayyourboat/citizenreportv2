import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //comes along with the multiple image picker plugin
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'function_appimagepicker.dart';
import 'button_submit.dart';
import 'function_appimagepicker.dart';
import 'size_config.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //File _getPicture;
  Future<File> _imageFile, getPicture;
  SimpleDialog sd;

  var _reports = [
    'Medical Emergencies',
    'Vehicular Accident',
    'Earthquake',
    'Fire Emergency',
    'Flooding',
    'Robbery / Theft',
    'Others'
  ];
  var _currentItemSelected = 'Medical Emergencies';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init();
    return Scaffold(
        appBar: GradientAppBar(
          title: Text('CITIZEN REPORTING'),
          centerTitle: true,
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purpleAccent]
          ),
        ),
        body: Center( //basis: https://api.flutter.dev/flutter/material/IconButton-class.html
            child: Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*10),
                child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(color: Colors.blueAccent)]),
                        child: showImage(),
                      ),
                      new Container(
                        padding: EdgeInsets.all(20.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.purple)
                            ),
                            color: Colors.white,
                            textColor: Colors.purple,
                            child: Text('UPLOAD IMAGE', style: TextStyle(fontSize: 20),),
                            onPressed: (){
                              showImageOptions();
                            },
                          ),
                          /*
                          IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                //solution 1 link: https://stackoverflow.com/questions/53294551/showdialog-from-root-widget
                                //solution 2 link: https://stackoverflow.com/questions/54035175/flutter-showdialog-alertdialog-no-materiallocalizations-found
                                //solution 3 link: https://stackoverflow.com/questions/44656013/flutter-simpledialog-in-floatingactionbutton
                                showImageOptions();
                              } //buildercontexthere
                          )
                          */
                      ),
                      new Container( //source code here for Container solution on TextFormField width issue: https://stackoverflow.com/questions/50400529/how-to-update-flutter-textfields-height-and-width
                          width: 250.0,
                          child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              //source  https://medium.com/flutter-community/a-deep-dive-into-flutter-textfields-f0e676aaab7a
                              decoration: new InputDecoration(
                                icon: Icon(Icons.report),
                                labelText: 'Insert Report Title Here',
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20
                                ),
                              ),
                              validator: (
                                  val) { //used for checking if the input has a value or contains something
                                if (val.length == 0) {
                                  return "Report field cannot be empty.";
                                }
                                else {
                                  return null;
                                }
                              }
                          )
                      ),
                      new Container(
                        padding: EdgeInsets.all(10.0),
                        child: DropdownButton<String>(
                          items: _reports.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                          value: _currentItemSelected,
                        ),
                      ),
                      new Container( //source code here for Container solution on TextFormField width issue: https://stackoverflow.com/questions/50400529/how-to-update-flutter-textfields-height-and-width
                          padding: EdgeInsets.all(10.0),
                          width: 250.0,
                          child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 7,
                              decoration: new InputDecoration(
                                labelText: 'Insert Report Details here',
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10
                                ),
                              ),
                              validator: (
                                  val) { //used for checking if the input has a value or contains something
                                if (val.length == 0) {
                                  return "Report field cannot be empty.";
                                }
                                else {
                                  return null;
                                }
                              }
                          )
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: CustomButton(
                            title: 'SUBMIT REPORT',
                            onPressed: () {

                            }
                        ),
                      )
                    ]
                )
            )
        )
    );
  }

  void showImageOptions() {

    sd = SimpleDialog(
        title: Text("Camera/Gallery"),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('Pick From Gallery'),
            onPressed: () async { //sample from: http://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter
              Navigator.pop(context);
              _getImage(ImageSource.gallery);
            },
          ),
          SimpleDialogOption(
              child: const Text('Capture image from Camera'),
              onPressed: () async { //sample from: http://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              }
          )
        ]
    );
    //this._imageFile == null ? Placeholder() : Image.file(this._imageFile); //uncomment this later on
    showDialog(context: context, child: sd);
  }

  _getImage(ImageSource src) async {
    getPicture = ImagePicker.pickImage(source: src, maxHeight: 200.0, maxWidth: 200.0); //await ImagePicker.pickImage(source: src, maxHeight: 200.0, maxWidth: 200.0)
    setState(() {
      this._imageFile = getPicture;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: getPicture,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 100,
            height: 100,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }



}
