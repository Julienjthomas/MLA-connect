import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/office_message_model.dart';
import '../../../data/services/office_messages_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatController extends GetxController {
  final _messages = OfficeMessagesService();
  final _auth = Get.find<AuthController>();

  final bodyController = TextEditingController();
  final RxString category = 'personal'.obs;
  final RxList<OfficeMessageModel> items = <OfficeMessageModel>[].obs;
  final RxBool loading = false.obs;
  final RxBool sending = false.obs;

  static const categories = <String, String>{
    'personal': 'Personal message',
    'request': 'Request',
    'invitation': 'Invitation',
    'other': 'Other',
  };

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    bodyController.dispose();
    super.onClose();
  }

  Future<void> load() async {
    final uid = _auth.userId;
    if (uid == null) return;
    loading.value = true;
    try {
      final cid = _auth.user.value?.constituencyId;
      items.value = await _messages.listForUser(userId: uid, constituencyId: cid);
    } catch (_) {
      items.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> send() async {
    final uid = _auth.userId;
    final cid = _auth.user.value?.constituencyId;
    if (uid == null || cid == null) {
      Get.snackbar('Profile', 'Please complete constituency selection in onboarding/profile.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final body = bodyController.text.trim();
    if (body.isEmpty) {
      Get.snackbar('Message', 'Please enter a message.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    sending.value = true;
    try {
      await _messages.send(
        userId: uid,
        constituencyId: cid,
        category: category.value,
        body: body,
      );
      bodyController.clear();
      await load();
    } catch (_) {
      Get.snackbar('Error', 'Could not send message. Try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      sending.value = false;
    }
  }
}
