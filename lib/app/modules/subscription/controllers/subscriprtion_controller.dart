import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import '../../../../common_widgets/custom_info_dialouge.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/country_list_model.dart';
import '../../../../models/gender_model.dart';
import '../../../../models/highest_edu_model.dart';
import '../../../../models/membership_type_model.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../referenceMemberList/models/reference_member_list_model.dart';
import '../../registration/models/sign_up_other_info_model.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  RxBool isCountryLoading = true.obs;

  var countryList = <SingleCountry>[].obs;

  var bloodGroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  var selectedBloodGroup = "";

  var membershipTypes = <String>[].obs;
  var selectedMembership = MembershipType().obs;

  var educationDegrees = <String>[].obs;
  var selectedDegree = HighestEdu().obs;

  var genders = <String>[].obs;
  var selectedGender = "";

  var isDiabetes = false.obs;
  var selectedCondition = "".obs;
  var isAccepted = true.obs;
  var pageIndex = 0.obs;
  Map<String, String> formData = {};

  ScrollController scrollController = ScrollController();
  var signUpOtherInfoModel = SignUpOtherInfoModel().obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var emergencyContactController = TextEditingController();
  var addressController = TextEditingController();
  var referenceMemberController = TextEditingController();

  RxMap<String, bool> acceptedTerms = <String, bool>{}.obs;

  final List<HealthCondition> healthConditions = [
    HealthCondition(key: "diabetes", label: "Diabetes"),
    HealthCondition(key: "bp", label: "Blood Pressure"),
    HealthCondition(key: "heart_condition", label: "Heart Conditions"),
    HealthCondition(key: "other", label: "Other"),
    HealthCondition(key: "none", label: "None"),
  ];

  final RxList<String> selectedConditions = <String>[].obs;

  var selectedReferenceMember = SingleReferenceMember().obs;
  var sportsController = TextEditingController();
  var hobbiesController = TextEditingController();
  var joiningReasonController = TextEditingController();
  var nidController = TextEditingController();
  var profileController = TextEditingController();
  var tinController = TextEditingController();
  var cvController = TextEditingController();

  RxList<File> nidFile = <File>[].obs;
  RxList<File> cvFile = <File>[].obs;
  RxList<File> profilePictureFile = <File>[].obs;
  RxList<File> tinCertificateFiles = <File>[].obs;

  var showPassword = false.obs;

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var selectedPhoneCountry = SingleCountry().obs;
  var selectedEmergencyContactCountry = SingleCountry().obs;

  @override
  void onInit() {
    super.onInit();
    _loadCountryList();
    _getSignUpOtherInfo();
  }

  Future<void> _loadCountryList() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/countries_with_phone_length.json',
      );

      final CountryListModel countryModel = countryListModelFromJson(response);
      final countries = countryModel.data ?? [];

      if (countries.isNotEmpty) {
        countryList.value = countries;

        final bdCountry = countries.firstWhereOrNull(
              (value) => (value.iso31662 ?? "").toLowerCase() == "bd",
        );

        selectedPhoneCountry.value = bdCountry ?? countries.first;
        selectedEmergencyContactCountry.value = bdCountry ?? countries.first;

        countryList.refresh();
      }
    } catch (e) {
      debugPrint("❌ Error loading country list: $e");
    } finally {
      isCountryLoading.value = false;
    }
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
    return list
        .where((e) => e.title != null)
        .map((e) {
          if (e.title == "Affiliate") {
            return "${e.title} (Free)";
          }
          return e.title!;
        })
        .toList()
        .obs;
  }

  RxList<String> getGenders(Gender gender) {
    return [
      if (gender.female != null) gender.female!,
      if (gender.male != null) gender.male!,
      if (gender.other != null) gender.other!,
    ].obs;
  }

  void getSelectedMemberShip(String? value) {
    if (value == null) return;

    // "(Free)" থাকলে সেটা সরিয়ে ফেলা
    final cleanValue = value.replaceAll(" (Free)", "").trim();
    final list = signUpOtherInfoModel.value.data?.membershipTypes ?? [];
    final selected = list.firstWhereOrNull((e) => e.title == cleanValue);



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

  void toggleCondition(String key) {
    if (selectedConditions.contains(key)) {
      selectedConditions.remove(key);
    } else {
      selectedConditions.add(key);
    }
    if (key == "none") {
      selectedConditions.value = ["none"];
    } else {
      selectedConditions.remove("none");
    }
  }

  void selectImage({
    required ImageSource source,
    required String fileType,
  }) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // Process the image (e.g., save or display it)
      if (fileType == "NID") {
        nidFile.add(File(pickedFile.path));
        nidController.text = pickedFile.name;
      }
      if (fileType == "CV") {
        cvFile.add(File(pickedFile.path));
        cvController.text = pickedFile.name;
      }
      if (fileType == "PROFILE") {
        profilePictureFile.add(File(pickedFile.path));
        profileController.text = pickedFile.name;
      }
      if (fileType == "TIN") {
        tinCertificateFiles.add(File(pickedFile.path));
        tinController.text = pickedFile.name;
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
          nidController.text = file.name;
        }
        if (fileType == "CV") {
          cvFile.add(File(file.path ?? ""));
          cvController.text = file.name;
        }
        if (fileType == "PROFILE") {
          profilePictureFile.add(File(file.path ?? ""));
          profileController.text = file.name;
        }
        if (fileType == "TIN") {
          tinCertificateFiles.add(File(file.path ?? ""));
          tinController.text = file.name;
        }
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

  void completeRegistration() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.completeSubscription;

    formData = {
      "mobile": (phoneController.text.isNotEmpty && selectedPhoneCountry.value.callingCode != null)
          ? selectedPhoneCountry.value.callingCode! + phoneController.text
          : "",
      "address": addressController.text,
      "gender": selectedGender,
      "emargency_contact": (emergencyContactController.text.isNotEmpty &&
          selectedEmergencyContactCountry.value.callingCode != null)
          ? selectedEmergencyContactCountry.value.callingCode! +
          emergencyContactController.text
          : "",
      "blood_group": selectedBloodGroup,
      "membership_type_id": selectedMembership.value.id.toString(),
      "highest_edu": selectedDegree.value.name ?? "",
      "sports_text": sportsController.text,
      "hobbies_text": hobbiesController.text,
      "club_text": joiningReasonController.text,
      //"ref_member_id": selectedReferenceMember.value.id.toString(),
    };


    Map<String, File?> files = {
      "nid": nidFile.isNotEmpty ? nidFile.first : null,
      "profile_picture":
          profilePictureFile.isNotEmpty ? profilePictureFile.first : null,
      "tin": tinCertificateFiles.isNotEmpty ? tinCertificateFiles.first : null,
      "cv": cvFile.isNotEmpty ? cvFile.first : null,
    };

    try {
      var response = await RemoteServices.userSubscription(
        endpoint: endpoint,
        formData: formData,
        files: files,
        healthConditions: healthConditions,
      );
      if (response != null) {
        CustomSnackBar(
          isSuccess: true,
          msg: response["msg"] ?? response["message"] ?? "Something went wrong",
        ).showSnackBar();

        await goToHome();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToHome() async {
    await getUserData().then((value) {
      Get.offAllNamed(Routes.HOME);
    });
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getUserData;
    try {
      var res = await RemoteServices.getRequest(endpoint: endpoint);
      if (res != null) {
        UserDataModel userDataModel = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.data ?? UserData());
        if ((userDataModel.data?.subscriptionStatus ?? "").toLowerCase() ==
            "pending") {
          Get.offAllNamed(Routes.SUBSCRIPRTION);
        } else {
          Get.offAndToNamed(Routes.HOME);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class HealthCondition {
  final String key;
  final String label;

  HealthCondition({required this.key, required this.label});
}
