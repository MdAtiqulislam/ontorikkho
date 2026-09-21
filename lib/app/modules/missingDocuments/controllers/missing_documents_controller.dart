import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../models/missing_documents_model.dart';

class MissingDocumentsController extends GetxController {
  var isLoading = false.obs;
  var missingDocuments = <SingleMissingDocument>[].obs;


  var missingDocumentList = <SingleMissingDocument>[].obs;
  var pendingDocumentList = <SingleMissingDocument>[].obs;

  var missingDocumentCount = 0.obs;
  var pendingDocumentCount = 0.obs;



  var selectedFiles = <int, File>{}.obs;

  @override
  void onInit() {
    getMissingDocuments();
    super.onInit();
  }

  Future<void> getMissingDocuments() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getMissingDocuments;

    try {
      var res = await RemoteServices.getRequest(endpoint: endpoint);

      if (res != null) {
        MissingDocumentsModel missingDocumentsModel = MissingDocumentsModel.fromJson(res);
        missingDocuments.value = missingDocumentsModel.data ?? [];

        // ✅ Filter missing documents (document_media_id == null)
        missingDocumentList.value = missingDocuments
            .where((doc) => doc.documentMediaId == null)
            .toList();
        missingDocumentCount.value = missingDocumentList.length;

        // ✅ Filter pending documents (document_media_id != null && admin_status == "Pending")
        pendingDocumentList.value = missingDocuments
            .where((doc) =>
        doc.documentMediaId != null &&
            (doc.adminStatus?.toLowerCase() == "pending"))
            .toList();
        pendingDocumentCount.value = pendingDocumentList.length;

      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ImagePicker for camera/gallery image
  void selectImage({
    required ImageSource source,
    required int documentId,
  }) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedFiles[documentId] = File(pickedFile.path);
      selectedFiles.refresh();
    }
  }

  /// File picker for any file type
  void handleDocumentSelection({required int documentId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      selectedFiles[documentId] = File(result.files.first.path ?? "");
      selectedFiles.refresh();
    }
  }

  /// Upload all selected files to API
  Future<void> uploadAllDocuments() async {
    if (selectedFiles.isEmpty) {
      CustomSnackBar(
        isSuccess: false,
        msg: "Please select at least one document."
      ).showSnackBar();
      return;
    }

    isLoading.value = true;

    try {
      var res = await RemoteServices.missingDocumentUpload(
        documentIds: selectedFiles.keys.toList(),
        files: selectedFiles.values.toList(),
        endpoint: APIEndPoints.uploadMissingDocuments,
      );

      if (res != null) {
        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"]
        ).showSnackBar();
        selectedFiles.clear();
        getMissingDocuments(); // refresh
        Get.put(HomeController()).getMissingDocuments();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void removeSelectedFile(int documentId) {
    selectedFiles.remove(documentId);
    update();
    selectedFiles.refresh();
  }


}
