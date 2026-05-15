import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/office_message_model.dart';
import '../../../data/services/office_messages_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatController extends GetxController {
  final _messages = OfficeMessagesService();
  final _auth = Get.find<AuthController>();

  final bodyController = TextEditingController();
  final scrollController = ScrollController();
  final RxList<OfficeMessageModel> items = <OfficeMessageModel>[].obs;
  final RxBool loading = false.obs;
  final RxBool sending = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    bodyController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  ({int citizenId, int constituencyId})? get _ids {
    final user = _auth.user.value;
    final cid = int.tryParse(user?.citizenRowId ?? '');
    final consId = int.tryParse(user?.constituencyId ?? '');
    if (cid == null || consId == null) return null;
    return (citizenId: cid, constituencyId: consId);
  }

  Future<void> load() async {
    final ids = _ids;
    if (ids == null) return;
    loading.value = true;
    try {
      items.value = await _messages.listForThread(
        citizenId: ids.citizenId,
        constituencyId: ids.constituencyId,
      );
      _scrollToBottom();
    } catch (_) {
      items.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> send() async {
    final ids = _ids;
    if (ids == null) {
      Get.snackbar('Profile', 'Please complete your profile before sending a message.',
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
        citizenId: ids.citizenId,
        constituencyId: ids.constituencyId,
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
