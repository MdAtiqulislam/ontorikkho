import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/missing_documents_controller.dart';

class MissingDocumentsView extends GetView<MissingDocumentsController> {
  MissingDocumentsView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          minimal: true,
          scaffoldKey: _scaffoldKey,
          showBackButton: true,
          title: "Upload Documents",
        ),
        drawer: MyDrawer(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.missingDocumentList.isEmpty) {
            return const EmptyScreen(
              animationPath: 'assets/animations/success.json',
              title: "All documents uploaded!",
              message: "You’ve successfully submitted all required files.",
            );

          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.missingDocumentList.length,
                  itemBuilder: (context, index) {
                    final doc = controller.missingDocumentList[index];
                    final selectedFile =
                    controller.selectedFiles[doc.documentId ?? 0];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.description_outlined, size: 30),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.name ?? "Unknown Document",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Status: ${doc.adminStatus ?? 'Pending'}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    chooseFileOption(documentId: doc.documentId ?? 0);
                                  },
                                  icon: Icon(
                                    selectedFile == null
                                        ? Icons.upload_file
                                        : Icons.change_circle_outlined,
                                    size: 18,
                                  ),
                                  label: Text(
                                    selectedFile == null ? "Choose File" : "Change",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                ),
                              ],
                            ),
                            if (selectedFile != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.insert_drive_file, size: 18, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        selectedFile.path.split('/').last,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.removeSelectedFile(doc.documentId ?? 0);
                                      },
                                      icon: const Icon(Icons.close_rounded,
                                          size: 18, color: Colors.redAccent),
                                      tooltip: "Remove File",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );

                  },
                ),
              ),
              if (controller.selectedFiles.isNotEmpty)
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                child: AppButton(text: "Upload", onTap: (){
                  controller.uploadAllDocuments();
                },bgColor: AppColors.primaryColor,),
              )
            ],
          );
        }),
      ),
    );
  }

  void chooseFileOption({required int documentId}) {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          _buildOption(
            iconPath: AppImagePath.cameraIcon,
            text: "Open Camera",
            subText: "Capture an image using your camera",
            onTap: () {
              controller.selectImage(
                source: ImageSource.camera,
                documentId: documentId,
              );
              Get.back();
            },
          ),
          const Divider(),
          _buildOption(
            iconPath: AppImagePath.galleryIcon,
            text: "Choose File",
            subText: "Select file from gallery or storage",
            onTap: () {
              controller.handleDocumentSelection(documentId: documentId);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required String subText,
    required VoidCallback onTap,
  })
  {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [
                Image.asset(iconPath, height: 30.h),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: text),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: BodyText(
                        text: subText,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
