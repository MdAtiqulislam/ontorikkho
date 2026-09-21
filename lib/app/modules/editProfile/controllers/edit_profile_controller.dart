import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/app/modules/ownProfile/controllers/own_profile_controller.dart';
import 'package:ontorikkho/app/modules/userPersonalData/controllers/user_personal_data_controller.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/models/country_list_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import '../../../../common_widgets/custom_info_dialouge.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/gender_model.dart';
import '../../../../models/highest_edu_model.dart';
import '../../../../models/membership_type_model.dart';
import '../../../../services/remote_services.dart';
import '../../registration/models/sign_up_other_info_model.dart';

class EditProfileController extends GetxController {

  var isLoading=false.obs;
  var isUpdating=false.obs;
  var user=UserDataModel().obs;

  var nameController=TextEditingController();
  var emailController=TextEditingController();

  var selectedPhoneCountry=SingleCountry();
  var phoneController=TextEditingController();
  SingleCountry selectedEmergencyContactCountry=SingleCountry();
  var emergencyContactController=TextEditingController();

  var genders = <String>[].obs;
  var selectedGender = "";


  var signUpOtherInfoModel = SignUpOtherInfoModel().obs;
  var addressController = TextEditingController();
  var referenceMemberController = TextEditingController();

  var membershipTypes = <String>[].obs;
  var selectedMembership = MembershipType().obs;

  var educationDegrees = <String>[].obs;
  var selectedDegree = HighestEdu().obs;

  var bloodGroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  var selectedBloodGroup = "";
  var isAccepted = true.obs;
  RxMap<String, bool> acceptedTerms = <String, bool>{}.obs;
  var sportsController = TextEditingController();
  var hobbiesController = TextEditingController();

  var countryList=<SingleCountry>[].obs;

  RxList<File> nidFile = <File>[].obs;
  RxList<File> cvFile = <File>[].obs;
  RxList<File> profilePictureFile = <File>[].obs;
  RxList<File> tinCertificateFiles = <File>[].obs;

  @override
  void onInit()async {
    super.onInit();
    _loadCountryList();
    await fetchData().then((_){preloadData();});

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _getData({bool?isLoadingNew}) async{
   (isLoadingNew??true)? isLoading.value=true:isUpdating.value=true;
    var endpoint=APIEndPoints.getUserData;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        user.value=UserDataModel.fromJson(rs);
        LocalServices.storeUserData(user.value.data??UserData());
        Get.put(UserPersonalDataController()).user.value=user.value;
        Get.put(OwnProfileController()).getUserData();
        Get.put(HomeController()).getUserData();
      }
    } finally {
      (isLoadingNew??false)? isLoading.value=false:isUpdating.value=false;
    }
  }

  RxList<String> getGenders(Gender gender) {
    return [
      if (gender.female != null) gender.female!,
      if (gender.male != null) gender.male!,
      if (gender.other != null) gender.other!,
    ].obs;
  }

  Future<void> _getSignUpOtherInfo() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getSignUpOtherInfo;
    try {
      var response = await RemoteServices.getRequest(endpoint: endPoint);
      if (response != null) {
        signUpOtherInfoModel.value = SignUpOtherInfoModel.fromJson(response);
        membershipTypes = getMembershipTypes(
          signUpOtherInfoModel.value.data?.membershipTypes ?? [],
        );
        educationDegrees = getEducationDegrees(
          signUpOtherInfoModel.value.data?.highestEdu ?? [],
        );
        genders = getGenders(
          signUpOtherInfoModel.value.data?.gender ?? Gender(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
  RxList<String> getMembershipTypes(List<MembershipType> list) {
    return list.where((e) => e.title != null).map((e) => e.title!).toList().obs;
  }

  RxList<String> getEducationDegrees(List<HighestEdu> list) {
    return list.where((e) => e.name != null).map((e) => e.name!).toList().obs;
  }

  void getSelectedDegree(String? value) {
    if (value == null) return;
    final list = signUpOtherInfoModel.value.data?.highestEdu ?? [];

    final selected = list.firstWhereOrNull((e) => e.name == value);

    if (selected != null) {
      selectedDegree.value = selected;
    }
  }

  void getSelectedMemberShip(String? value) {
    if (value == null) return;

    final list = signUpOtherInfoModel.value.data?.membershipTypes ?? [];

    final selected = list.firstWhereOrNull((e) => e.title == value);

    if (selected != null) {
      acceptedTerms.clear();

      if ((selected.amount ?? 0) <= 0) {
        selectedMembership.value = selected;
        getMembershipFeeCheckboxes();
      } else {
        Get.dialog(
          CustomInfoDialog(
            title: "Attention",
            description: _buildDescription(selected),
            onAccept: () {
              selectedMembership.value = selected;
              getMembershipFeeCheckboxes();
            },
            acceptText: "Ok",
          ),
        );
      }
    }
  }
  String _buildDescription(MembershipType selected) {
    final title = selected.title ?? "";
    final amount = selected.amount ?? 0;
    final inductionFees = selected.inductionFees ?? 0;
    if (inductionFees > 0 && amount > 0) {
      return "Please be informed that you have to pay an induction fees of BDT $inductionFees and a yearly renewal fee of BDT $amount for $title membership.";
    } else if (amount > 0) {
      return "Please be informed that you have to pay a yearly renewal fee of BDT $amount for $title membership.";
    } else {
      return "You have selected the $title membership plan.";
    }
  }

  List<String> getMembershipFeeCheckboxes() {
    final selected = selectedMembership.value;
    final List<String> checkboxes = [];

    if (selected.title == "Affiliate") {
      return checkboxes; // No checkboxes
    }

    if ((selected.amount ?? 0) > 0 && (selected.inductionFees ?? 0) > 0) {
      checkboxes.add(
        "I understand that I have to pay an Induction Fee of BDT ${selected.inductionFees}",
      );
      checkboxes.add(
        "I understand that I have to pay BDT ${selected.amount} per year as membership fees",
      );
    } else if ((selected.amount ?? 0) > 0) {
      checkboxes.add(
        "I understand that I have to pay BDT ${selected.amount} per year as membership fees",
      );
    }

    return checkboxes;
  }

 Future<void> fetchData() async{
  await _getData();
  await _getSignUpOtherInfo();
  
 }

  void preloadData() {
    profilePictureFile.value=[];
    final data = user.value.data;
    if (data == null) return;

    nameController.text = data.name ?? "";
    emailController.text = data.email ?? "";
    phoneController.text = removeCountryCode(data.mobile ?? "", "880");
    emergencyContactController.text = removeCountryCode(data.emargencyContact ?? "", "880");
    addressController.text = data.address ?? "";
    sportsController.text = data.sports ?? "";
    hobbiesController.text = data.hobbies ?? "";

    // ✅ Gender
    if (genders.contains(data.gender)) {
      selectedGender = data.gender ?? "";
    }

    // ✅ Blood Group
    if (bloodGroup.contains(data.bloodGroup)) {
      selectedBloodGroup = data.bloodGroup ?? "";
    }

    // ✅ Membership
    final allMemberships = signUpOtherInfoModel.value.data?.membershipTypes ?? [];
    final selectedM = allMemberships.firstWhereOrNull((e) => e.title == data.membershipType);
    if (selectedM != null) {
      selectedMembership.value = selectedM;
      getMembershipFeeCheckboxes();
    }

    selectedPhoneCountry=getSelectedCountry(callingCode: "880");
    selectedEmergencyContactCountry=getSelectedCountry(callingCode: "880");

    // ✅ Education
    final allDegrees = signUpOtherInfoModel.value.data?.highestEdu ?? [];
    final selectedEdu = allDegrees.firstWhereOrNull((e) => e.name == data.highestEdu);
    if (selectedEdu != null) {
      selectedDegree.value = selectedEdu;
    }

  }

  Future<void> submitEditForm() async {
    Map<String, String> body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": (selectedPhoneCountry.callingCode??"")+phoneController.text.trim(),
      "address": addressController.text.trim(),
      "gender": selectedGender.trim(),
      "emargency_contact": emergencyContactController.text.trim(),
      "blood_group": selectedBloodGroup.trim(),
      "membership_type_id": (selectedMembership.value.id ?? "").toString(),
      "highest_edu": (selectedDegree.value.id ?? "").toString(),
      "sports_text": sportsController.text.trim(),
      "hobbies_text": hobbiesController.text.trim(),
      "club_text": "", // Add if needed
    };

    isUpdating.value = true;

    try {
      var response = await RemoteServices.multipartRequest(
        endpoint: APIEndPoints.updateUserData,
        body: body,
        filePath: profilePictureFile.isNotEmpty ? profilePictureFile.first.path : "",
        fieldName: 'profile_picture',
        requestType: 'POST',
      );

      if (response != null) {
        CustomSnackBar(
          isSuccess: true,
          msg: response["msg"],
        ).showSnackBar();

        /// ✅ Reload updated data after successful update
       await _getData(isLoadingNew: false);
        preloadData();

      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> _loadCountryList() async {
    final String response = await rootBundle.loadString(
      'assets/data/countries_with_phone_length.json',
    );
    final CountryListModel countryModel = countryListModelFromJson(response);
      countryList.value = countryModel.data ?? [];
  }

  String removeCountryCode(String number, String callingCode) {
    if (number.startsWith(callingCode)) {
      return number.substring(callingCode.length); // remove prefix
    }
    return number;
  }


  SingleCountry getSelectedCountry({required String callingCode}) {
    return countryList.firstWhere(
          (element) => element.callingCode == callingCode,
      orElse: () => SingleCountry(), // Return empty object if not found
    );
  }

  void selectImage({
    required ImageSource source,
    required String fileType,
  })
  async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // Process the image (e.g., save or display it)
      if (fileType == "NID") {
        nidFile.add(File(pickedFile.path));
      //  nidController.text = pickedFile.name;
      }
      if (fileType == "CV") {
        cvFile.add(File(pickedFile.path));
      //  cvController.text = pickedFile.name;
      }
      if (fileType == "PROFILE") {
        profilePictureFile.add(File(pickedFile.path));
      //  profileController.text = pickedFile.name;
      }
      if (fileType == "TIN") {
        tinCertificateFiles.add(File(pickedFile.path));
       // tinController.text = pickedFile.name;
      }
    }
  }

  void handleDocumentSelection({required String fileType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result != null) {
      for (var file in result.files) {
        if (fileType == "NID") {
          nidFile.add(File(file.path ?? ""));
         // nidController.text = file.name;
        }
        if (fileType == "CV") {
          cvFile.add(File(file.path ?? ""));
         // cvController.text = file.name;
        }
        if (fileType == "PROFILE") {
          profilePictureFile.add(File(file.path ?? ""));
         // profileController.text = file.name;
        }
        if (fileType == "TIN") {
          tinCertificateFiles.add(File(file.path ?? ""));
        //  tinController.text = file.name;
        }
      }
    }
  }

  // Returns true if all membership checkboxes are checked
  bool get areAllTermsAccepted {
    if (acceptedTerms.isEmpty) return true; // No checkboxes, allow save
    return acceptedTerms.values.every((v) => v == true);
  }


}
