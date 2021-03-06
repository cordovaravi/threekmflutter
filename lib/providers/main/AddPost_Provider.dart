import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:threekm/Models/SignedUrl_model.dart';
import 'package:threekm/UI/main/AddPost/BottomSnack.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/main.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

// // for callback of upload
// typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
// bool trustSelfSigned = true;
// HttpClient getHttpClient() {
//   HttpClient httpClient = new HttpClient()
//     ..connectionTimeout = const Duration(seconds: 10)
//     ..badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => trustSelfSigned);

//   return httpClient;
// }

class AddPostProvider extends ChangeNotifier {
  bool editMode = false;
  final ApiProvider _apiProvider = ApiProvider();
  final client = Dio();
  List<String> _tagsList = [];
  List<String> get tagsList => _tagsList;
  String _description = '';
  String get description => _description;

  int fileUploded = 0;

  set description(String text) {
    _description = text;
  }

  String? tempURl = null;

  Future<Null> addTags(String tagItem) async {
    _tagsList.add(tagItem);
    notifyListeners();
  }

  void removeTag(String tag) {
    _tagsList.remove(tag);
    notifyListeners();
  }

  /// Images
  List<File> _moreImages = [];
  List<File> get getMoreImages => _moreImages;

  void addImages(File image) {
    _moreImages.add(image);
    notifyListeners();
  }

  Future removeImages(int Index) async {
    _moreImages.removeAt(Index);
    notifyListeners();
  }

  void asignImages(images) {
    List<XFile> tempimages = images;
    //_moreImages = images;
    tempimages.forEach((element) {
      _moreImages.add(File(element.path));
    });
    notifyListeners();
  }

  void insertImage(int index, File image) {
    _moreImages.insert(index, image);
    notifyListeners();
  }

  void deletImages() {
    _moreImages.clear();
    notifyListeners();
  }

  /// Post
  String? _selectedAddress;
  String? get selectedAddress => _selectedAddress;
  set selectedAddress(String? text) {
    _selectedAddress = text;
    notifyListeners();
  }

  Geometry? _geometry;
  Geometry? get geometry => _geometry;
  set geometry(Geometry? geometry) {
    _geometry = geometry;
    notifyListeners();
  }

  List<String> _uploadImageUrls = [];
  List<String> get uploadedImagesUrl => _uploadImageUrls;
  bool? _isUploaded;
  bool? get ispostUploaded => _isUploaded;
  bool _isUploadeerror = false;
  bool get isUploadError => _isUploadeerror;
  bool _islastUpload = false;
  //UploadedFileProvider _uploadedFileProvider = UploadedFileProvider();
  Future<Null> uploadPng(context, String? headLine, String? story,
      String? address, double? lat, double? long) async {
    if (_moreImages.isNotEmpty && _moreImages.length != null) {
      /// Showing snackbar of uploading
      //  showUploadingSnackbar(context, _moreImages.first);

      _moreImages.forEach((element) async {
        print("uploading");
        log("${element.path}");
        if (element.path.contains(".png") ||
            element.path.contains(".jpg") ||
            element.path.contains(".jpeg")) {
          try {
            String requestJson =
                json.encode({"fileextention": "png", "modulename": "news"});
            await initalizeUpload(context, headLine, story, address, lat, long,
                uploadFile: element, requestJson: requestJson);
            log("more img ${_moreImages.length}");
            log("upload imgs ${_uploadImageUrls.length}");
          } on Exception catch (e) {
            print(e);
            CustomSnackBar(context, Text("Upload Failed.!"));
          }
        } else if (element.path.contains(".mp4") ||
            element.path.contains(".mpeg") ||
            element.path.contains(".avi") ||
            element.path.contains(".mkv")) {
          try {
            String requestJson =
                json.encode({"fileextention": "mp4", "modulename": "news"});
            await initalizeUpload(context, headLine, story, address, lat, long,
                uploadFile: element, requestJson: requestJson);
          } on Exception catch (e) {
            print(e);
            CustomSnackBar(context, Text("Upload Failed.!"));
          }
        }
      });
    } else {
      uploadPost(context, headLine, story, address, lat, long);
    }
  }

  ////
  ///New Code with Dio package to demonstrate % of upload

  //get signed urrl from
  SignedUrlModel? signedUrlData;

  String _uploadPercent = "0.0";
  String get uploadPercent => _uploadPercent;

  Future<String?> getsignedURl({required String requestJson}) async {
    final response = await _apiProvider.post(getSignedUrl, requestJson);

    if (response["status"] == "success") {
      log(response.toString());
      signedUrlData = null;
      signedUrlData = SignedUrlModel.fromJson(response);
      _uploadImageUrls.add(signedUrlData?.data?.result?.resourceUrl ?? "null");
      log("this is resorce url of file ${(signedUrlData?.data?.result?.resourceUrl ?? "null")}");
      log(_uploadImageUrls.toList().toString());
      return signedUrlData?.data?.result?.uploadUrl;
    }
  }

  Future<Null> initalizeUpload(context, String? headLine, String? story,
      String? address, double? lat, double? long,
      {required File uploadFile, required String requestJson}) async {
    String? signedUrl = await getsignedURl(requestJson: requestJson);
    log("\n");
    log(signedUrl ?? "nul");

    if (signedUrl != null) {
      try {
        Uint8List image = uploadFile.readAsBytesSync();

        Options options =
            Options(contentType: lookupMimeType(uploadFile.path), headers: {
          'Accept': "*/*",
          'Content-Length': image.length,
          'Connection': 'keep-alive',
          'User-Agent': 'ClinicPlush'
        });
        final fileUploadResponse = await client.put(signedUrl,
            data: uploadFile.openRead(),
            options: options, onSendProgress: (val1, val2) {
          log("${val1 / val2 * 100}");
          _uploadPercent = "${val1 / val2 * 100}";
          notifyListeners();
        });
        if (fileUploadResponse.statusCode == 200) {
          fileUploded++;
          log("file uploaded ");
          log(fileUploded.toString());
          log(_moreImages.length.toString());
          if (_moreImages.length == _uploadImageUrls.length &&
              _uploadPercent.contains("100.") &&
              _moreImages.length == fileUploded) {
            uploadPost(context, headLine, story, address, lat, long);
          }
          //notifyListeners();
          log(_uploadImageUrls.toList().toString());
          log(_moreImages.length.toString());
        } else {
          log(fileUploadResponse.statusCode.toString());
          CustomSnackBar(context, Text("Something went wrong"));
        }
      } on Exception catch (e) {
        log(e.toString());
      }
    }
  }

  int postUploaded = 0;
  Future<Null> uploadPost(context, String? headLine, String? story,
      String? address, double? lat, double? long) async {
    List tempImages = [];
    List _videosUrl = [];
    uploadedImagesUrl.forEach((element) {
      if (element.contains(".png") ||
          element.contains(".jpg") ||
          element.contains(".jpeg")) {
        tempImages.add(element);
      } else {
        SubmitVideo objvideoUrls = SubmitVideo(element);
        _videosUrl.add(objvideoUrls);
      }
    });
    log("this is Video urls list $_videosUrl");
    String requestJson = json.encode({
      "headline": "$headLine",
      "story": "$story",
      "images": tempImages.toList(),
      "videos": _videosUrl.toList(),
      "type": "Strory",
      "tags": _tagsList.toList(),
      // "areas": ["kothrud", "karve nagar"],
      "latitude": lat ?? 18.5204,
      "longitude": long ?? 73.8567,
      "location": address,
      // "business": [],
      // "products": []
    });

    final response = await _apiProvider.post(upload_post, requestJson);
    log(response.toString());
    //hideCurrentSnackBar(navigatorKey.currentContext);
    if (response != null) {
      hideCurrentSnackBar(navigatorKey.currentContext);
      if (response["status"] == "success") {
        log("post uploaded once $postUploaded");
        Future.delayed(Duration(seconds: 1), () {
          //CustomSnackBar(context, Text("Post Submitted"));
          Fluttertoast.showToast(
              msg: "Post has been Submitted",
              backgroundColor: Color(0xFF0044CE));
          _isUploaded = true;
          notifyListeners();
          Future.delayed(Duration.zero, () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => TabBarNavigation(
                          redirectedFromPost: false,
                          isPostUploaded: true,
                        )),
                (route) => false);
          });
        });
        resetUpload();
      } else {
        _isUploadeerror = true;
        notifyListeners();
      }
    }
  }

  void removeSnack() {
    _isUploaded = false;
    notifyListeners();
  }

  void resetUpload() {
    _uploadImageUrls.clear();
    _moreImages.clear();
  }

  void setPostUploaded() {
    postUploaded = 0;
    resetUpload();
    fileUploded = 0;
    notifyListeners();
  }

  // compression process
  LightCompressor? lightCompressor;
  bool isCompressionOngoing = false;

  void compressVideoFile(File pickedFile) async {
    String? _filePath;
    String _desFile;

    final File file = File(pickedFile.path);

    _filePath = file.path;

    lightCompressor = LightCompressor();
    isCompressionOngoing = true;
    notifyListeners();

    _desFile = await _destinationFile;

    final dynamic response = await lightCompressor?.compressVideo(
        path: _filePath,
        destinationPath: _desFile,
        videoQuality: VideoQuality.medium,
        isMinBitrateCheckEnabled: false,
        iosSaveInGallery: false);

    isCompressionOngoing = false;
    lightCompressor = null;
    notifyListeners();

    if (response is OnSuccess) {
      _desFile = response.destinationPath;
      addImages(File(response.destinationPath));
    } else if (response is OnFailure) {
      Fluttertoast.showToast(
          msg: "Unable to process video.\nPlease try again later.");
      print("compression failed");
    } else if (response is OnCancelled) {
      Fluttertoast.showToast(msg: "Cancelled");
      print("compression cancelled");
    }
  }

  Future<String> get _destinationFile async {
    String directory;
    final String videoName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    if (Platform.isAndroid) {
      // Handle this part the way you want to save it in any directory you wish.
      final List<Directory>? dir = await path.getExternalStorageDirectories(
          type: path.StorageDirectory.movies);
      directory = dir!.first.path;
      return File('$directory/$videoName').path;
    } else {
      final Directory dir = await path.getLibraryDirectory();
      directory = dir.path;
      return File('$directory/$videoName').path;
    }
  }
}

class SubmitVideo {
  String src;
  SubmitVideo(this.src);
  Map toJson() => {
        'src': src,
      };
}

// // class UploadedFileProvider extends ChangeNotifier {
// //   List<String> _uploadImageUrls = [];
// //   List<String> get uploadedImagesUrl => _uploadImageUrls;

// //   ApiProvider _apiProvider = ApiProvider();

// //   String requestJson =
// //       json.encode({"fileextention": "mp4", "modulename": "news"});

// //   //get signed urrl from
// //   Future<String?> getsignedURl() async {
// //     final response = await _apiProvider.post(getSignedUrl, requestJson);

// //     if (response["status"] == "success") {
// //       log(response.toString());
// //       final signedUrlData = SignedUrlModel.fromJson(response);
// //       uploadedImagesUrl.add(signedUrlData.data?.result?.uploadUrl ?? "");
// //       log(signedUrlData.data?.result?.resourceUrl ?? "null");
// //       return signedUrlData.data?.result?.uploadUrl;
// //     }
// //   }

// //   Future<Null> initalize({required File uploadFile}) async {
// //     String? signedUrl = await getsignedURl();
// //     log("\n");
// //     log(signedUrl ?? "nul");
// //     //////////// working code
// //     if (signedUrl != null) {
// //       try {
// //         Uint8List image = uploadFile.readAsBytesSync();

// //         Options options =
// //             Options(contentType: lookupMimeType(uploadFile.path), headers: {
// //           'Accept': "*/*",
// //           'Content-Length': image.length,
// //           'Connection': 'keep-alive',
// //           'User-Agent': 'ClinicPlush'
// //         });
// //         final response = await Dio().put(signedUrl,
// //             data: uploadFile.openRead(),
// //             options: options, onSendProgress: (val1, val2) {
// //           log("${val1 / val2 * 100}");
// //         });
// //         if (response.statusCode == 200) {
// //           log("file uploaded ");
// //         } else {
// //           log(response.toString());
// //         }
// //       } on Exception catch (e) {
// //         log(e.toString());
// //       }
// //     }
// //   }

  ///
//   Future<String?> fileUploadMultipart(
//       {required File file,
//       required OnUploadProgressCallback onUploadProgress}) async {
//     assert(file != null);

//     String? url = await getsignedURl();

//     final httpClient = getHttpClient();

//     final request = await httpClient.putUrl(Uri.parse(url!));

//     int byteCount = 0;

//     //var multipart = await http.MultipartFile.fromPath("post.png", file.path);

//     // final fileStreamFile = file.openRead();

//     // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
//     //     filename: fileUtil.basename(file.path));

//     var requestMultipart = http.MultipartRequest("POST", Uri.parse("$url"));

//     //requestMultipart.files.add(multipart);
//     //requestMultipart.fields['storage_url'] = "post";
//     //requestMultipart.fields['record_id'] = "0";
//     //requestMultipart.fields['filename'] = "post.png";

//     var msStream = requestMultipart.finalize();

//     var totalByteLength = requestMultipart.contentLength;

//     request.contentLength = totalByteLength;

//     final mimeType = lookupMimeType(file.path);

//     request.headers.set(HttpHeaders.contentTypeHeader, "$mimeType");
//     //var httpresponse = await requestMultipart.send();

//     Stream<List<int>> streamUpload = msStream.transform(
//       new StreamTransformer.fromHandlers(
//         handleData: (data, sink) {
//           sink.add(data);

//           byteCount += data.length;

//           if (onUploadProgress != null) {
//             onUploadProgress(byteCount, totalByteLength);
//             // CALL STATUS CALLBACK;
//             log(byteCount.toString());
//             log(totalByteLength.toString());
//           }
//         },
//         handleError: (error, stack, sink) {
//           throw error;
//         },
//         handleDone: (sink) {
//           sink.close();
//           // UPLOAD DONE;
//         },
//       ),
//     );

//     await request.addStream(streamUpload);

//     final httpResponse = await request.close();
// //
//     var statusCode = httpResponse.statusCode;

//     var postResponse = await httpResponse.transform(utf8.decoder).join();
//     print(postResponse);
//     // final parsedResponse = json.decode(postResponse);
//     // if (parsedResponse.statusCode == 200) {
//     //   if (parsedResponse["status"] == "success") {
//     //     print(parsedResponse["photo"]["photo"]);
//     //     _uploadImageUrls.add(parsedResponse["photo"]["photo"]);
//     //     notifyListeners();
//     //   }
//     // }

//     if (statusCode ~/ 100 != 2) {
//       throw Exception(
//           'Error uploading file, Status code: ${httpResponse.statusCode}');
//     } else {
//       //return await readResponseAsString(httpResponse);
//     }
//   }

  // Future<String> readResponseAsString(HttpClientResponse response) {
  //   var completer = new Completer<String>();
  //   var contents = new StringBuffer();
  //   response.transform(utf8.decoder).listen((String data) {
  //     contents.write(data);
  //   }, onDone: () => completer.complete(contents.toString()));
  //   print("this is compliter ${completer.future}");
  //   return completer.future;
  // }
//}
