import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:threekm/Models/SignedUrl_model.dart';
import 'package:threekm/UI/main/AddPost/BottomSnack.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/main.dart';

import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

// // for callback of upload
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
bool trustSelfSigned = true;
HttpClient getHttpClient() {
  HttpClient httpClient = new HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);

  return httpClient;
}

class AddPostProvider extends ChangeNotifier {
  bool editMode = false;
  final ApiProvider _apiProvider = ApiProvider();
  List<String> _tagsList = [];
  List<String> get tagsList => _tagsList;

  String? tempURl = null;

  Future<Null> addTags(String tagItem) async {
    _tagsList.add(tagItem);
    notifyListeners();
  }

  Future<Null> deletTag(int index) async {
    _tagsList.removeAt(index);
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

  List<String> _uploadImageUrls = [];
  List<String> get uploadedImagesUrl => _uploadImageUrls;
  bool? _isUploaded;
  bool? get ispostUploaded => _isUploaded;
  bool _isUploadeerror = false;
  bool get isUploadError => _isUploadeerror;
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
            initalizeUpload(context, headLine, story, address, lat, long,
                uploadFile: element, requestJson: requestJson);
            log("more img ${_moreImages.length}");
            log("upload imgs ${_uploadImageUrls.length}");
            // if (_moreImages.length == _uploadImageUrls.length) {
            //   uploadPost(context, headLine, story, address, lat, long);
            //   //notifyListeners();
            // }
            // var request = await http.MultipartRequest(
            //     'POST', Uri.parse(upload_Imagefile));
            // request.headers['Authorization'] = await _apiProvider.getToken();
            // request.fields['storage_url'] = "post";
            // request.fields['record_id'] = "0";
            // request.fields['filename'] = "post.png";
            // request.files
            //     .add(await http.MultipartFile.fromPath('file', element.path));
            // var httpresponse = await request.send();
            // final res = await http.Response.fromStream(httpresponse);
            // final response = json.decode(res.body);

            // if (httpresponse.statusCode == 200) {
            //   print("uploaded");
            //   if (response["status"] == "success") {
            //     log(response["photo"]["photo"]);
            //     _uploadImageUrls.add(response["photo"]["photo"]);
            //     //log(_uploadImageUrls.toList().toString());
            //     if (_moreImages.length == _uploadImageUrls.length) {
            //       log("progress is 100");
            //       uploadPost(context, headLine, story, address, lat, long);
            //       notifyListeners();
            //     }
            //   }
            // } else {
            //   CustomSnackBar(context, Text("Upload Failed.!"));
            // }
          } on Exception catch (e) {
            print(e);
            CustomSnackBar(context, Text("Upload Failed.!"));
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        } else if (element.path.contains(".mp4") ||
            element.path.contains(".mpeg") ||
            element.path.contains(".avi") ||
            element.path.contains(".mkv")) {
          try {
            String requestJson =
                json.encode({"fileextention": "mp4", "modulename": "news"});
            initalizeUpload(context, headLine, story, address, lat, long,
                uploadFile: element, requestJson: requestJson);
            // if (_moreImages.length == _uploadImageUrls.length) {
            //   log("more images lenght${_moreImages.length}");
            //   log("upload imges lenght ${_uploadImageUrls.length}");
            //   log("video progress is 100");
            //   uploadPost(context, headLine, story, address, lat, long);
            //   //notifyListeners();
            // }
            // String _token = await _apiProvider.getToken();
            // print("this is token $_token");
            // var request = await http.MultipartRequest(
            //     'POST', Uri.parse(upload_VideoFile));
            // request.headers['Authorization'] = _token;
            // request.fields['storage_url'] = "post";
            // request.fields['record_id'] = "0";
            // request.fields['filename'] = "post.mp4";
            // request.files
            //     .add(await http.MultipartFile.fromPath('file', element.path));
            // var httpresponse = await request.send();
            // final res = await http.Response.fromStream(httpresponse);
            // final response = json.decode(res.body);
            // if (httpresponse.statusCode == 200) {
            //   print("video uploaded");
            //   if (response["status"] == "success") {
            //     log("this is video response${response.toString()}");
            //     log(response["video"]["video"]);
            //     _uploadImageUrls.add(response["video"]["video"]);
            //     //log(_uploadImageUrls.toList().toString());
            //     if (_moreImages.length == _uploadImageUrls.length) {
            //       log("video progress is 100");
            //       uploadPost(context, headLine, story, address, lat, long);
            //       notifyListeners();
            //     }
            //   }
            // } else {
            //   CustomSnackBar(context, Text("Upload Failed.!"));
            // }
          } on Exception catch (e) {
            print(e);
            CustomSnackBar(context, Text("Upload Failed.!"));
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  String _uploadPercent = "";
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
    //////////// working code
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
        final response = await Dio().put(signedUrl,
            data: uploadFile.openRead(),
            options: options, onSendProgress: (val1, val2) {
          log("${val1 / val2 * 100}");
          _uploadPercent = "${val1 / val2 * 100}";
          notifyListeners();
        });
        if (response.statusCode == 200) {
          log("file uploaded ");
          // _uploadImageUrls.add(signedUrlData?.data?.result?.resourceUrl ?? "");

          if (_moreImages.length == _uploadImageUrls.length) {
            uploadPost(context, headLine, story, address, lat, long);
            // Future.delayed(Duration(seconds: 2), () {
            //   uploadPost(context, headLine, story, address, lat, long);
            // });
          }
          //notifyListeners();
          log(_uploadImageUrls.toList().toString());
          log(_moreImages.length.toString());
        } else {
          log(response.statusCode.toString());
          log(response.toString());
          CustomSnackBar(context, Text("Something went wrong"));
        }
      } on Exception catch (e) {
        log(e.toString());
      }
    }
  }

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
        // SubmitVideo submitVideo = SubmitVideo( element);
        // String objVideo = json.encode({submitVideo});
        // print(objVideo);
        // _videosUrl.add(objVideo);
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
      "latitude": lat,
      "longitude": long,
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
        Future.delayed(Duration(seconds: 1), () {
          //CustomSnackBar(context, Text("Post Submitted"));
          _isUploaded = true;
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
          resetUpload(context);
          notifyListeners();
        });
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

  void resetUpload(context) {
    _uploadImageUrls.clear();
    _moreImages.clear();
    //_videosUrl.clear();
    notifyListeners();
    // CustomSnackBar(context, Text("Post has been submmitted"));
  }
}

class SubmitVideo {
  String src;
  SubmitVideo(this.src);
  Map toJson() => {
        'src': src,
      };
}

class UploadedFileProvider extends ChangeNotifier {
  List<String> _uploadImageUrls = [];
  List<String> get uploadedImagesUrl => _uploadImageUrls;

  ApiProvider _apiProvider = ApiProvider();

  String requestJson =
      json.encode({"fileextention": "mp4", "modulename": "news"});

  //get signed urrl from
  Future<String?> getsignedURl() async {
    final response = await _apiProvider.post(getSignedUrl, requestJson);

    if (response["status"] == "success") {
      log(response.toString());
      final signedUrlData = SignedUrlModel.fromJson(response);
      uploadedImagesUrl.add(signedUrlData.data?.result?.uploadUrl ?? "");
      log(signedUrlData.data?.result?.resourceUrl ?? "null");
      return signedUrlData.data?.result?.uploadUrl;
    }
  }

  Future<Null> initalize({required File uploadFile}) async {
    String? signedUrl = await getsignedURl();
    log("\n");
    log(signedUrl ?? "nul");
    //////////// working code
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
        final response = await Dio().put(signedUrl,
            data: uploadFile.openRead(),
            options: options, onSendProgress: (val1, val2) {
          log("${val1 / val2 * 100}");
        });
        if (response.statusCode == 200) {
          log("file uploaded ");
        } else {
          log(response.toString());
        }
      } on Exception catch (e) {
        log(e.toString());
      }
    }
  }

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
}
