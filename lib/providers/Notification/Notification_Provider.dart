import 'package:flutter/material.dart';
import 'package:threekm/Models/Notification/NotificationModel.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class NotificationProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  NotificationModel? _notificationModel;
  NotificationModel? get NotificationDataList => this._notificationModel;

  Future<Null> getNotificationData() async {
    final response = await _apiProvider.get(Get_Notification);
    if (response != null && response["status"] == "success") {
      _notificationModel = NotificationModel.fromJson(response);
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    getNotificationData();
  }
}
