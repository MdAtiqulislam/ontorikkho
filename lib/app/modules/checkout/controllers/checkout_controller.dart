import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/checkout/models/bd_data_model.dart';
import 'package:ontorikkho/app/modules/checkout/models/last_shipping_address_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/country_list_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';


import '../../cart/controllers/cart_controller.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class CheckoutController extends GetxController {
  var isLoading = false.obs;
  var isCountryLoading = true.obs;
  // In CheckoutController
  RxBool isDifferentAddress = false.obs;
  var countryList = <SingleCountry>[].obs;
  var bdDataModel = BdDataModel().obs;
  var selectedDivision = "".obs;
  var selectedDistrict = "".obs;
 // var selectedUpazila = "".obs;
 // var selectedUnion = "".obs;
  var divisions = <String>[].obs;
  var districts = <String>[].obs;
  var upazilas = <String>[].obs;
  var unions = <String>[].obs;
  var subtotal = 0.0.obs;
  var discountTotal = 0.0.obs;
  var total=0.0.obs;
  var deliveryCharge = 150.0.obs;
  var savedShippingAddress=ShippingAddressData().obs;

  var userData=UserData().obs;
  var selectedPhoneCountry=SingleCountry().obs;
  var phoneController=TextEditingController();
  var streetAddressController=TextEditingController();
  final cartController = Get.put(CartController());
  var nameController=TextEditingController();
  var upazilaController=TextEditingController();
  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    _loadCountryList();
    getSavedDeliveryAddress();
    await getDeliveryCharge().then((value){getOrderSummary();});
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
        countryList.refresh();
      }
    } catch (e) {
      debugPrint("❌ Error loading country list: $e");
    } finally {
      isCountryLoading.value = false;
    }
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadData() async {
    String jsonString = await rootBundle.loadString('assets/data/bd_data.json');
    bdDataModel.value = BdDataModel.fromJson(json.decode(jsonString));
    bdDataModel.value.divisions?.forEach(
      (value) => divisions.add(value.name ?? ""),
    );
    userData.value=await LocalServices.getUserData()??UserData();
  }

  void loadDistricts({required String division}) {
    // Clear previous selections
    districts.clear();
    upazilas.clear();
    unions.clear();
    selectedDistrict.value = "";
    // selectedUpazila.value = "";
    // selectedUnion.value="";
    // Find selected division
    final selectedDiv = bdDataModel.value.divisions?.firstWhereOrNull(
      (d) => d.name == division,
    );

    if (selectedDiv != null) {
      for (var district in selectedDiv.districts ?? []) {
        districts.add(district.name ?? "");
      }
    }
  }

  void loadUpazilas({required String district}) {
    upazilas.clear();
  //  selectedUpazila.value = "";
    unions.clear();
  //  selectedUnion.value="";

    final selectedDiv = bdDataModel.value.divisions?.firstWhereOrNull(
          (d) => d.name == selectedDivision.value,
    );
    if (selectedDiv == null) {
      print("No division found");
      return;
    }
    final selectedDist = selectedDiv.districts?.firstWhereOrNull(
          (dist) => dist.name == district,
    );

    if (selectedDist == null) {
      print("No district found");
      return;
    }

  //  print("Selected District upazilas raw: ${selectedDist.upazilas}");

    for (var upa in selectedDist.upazilas ?? []) {
      if (upa is String) {
        upazilas.add(upa);
      } else if (upa is Map<String, dynamic>) {
        upazilas.add(upa["name"] ?? "");
      }
    }

   // print("Upazilas loaded: $upazilas");

    if (upazilas.isNotEmpty) {
    } else {
      unions.clear();
      //selectedUnion.value = "";
    }
  }


  void loadUnion({required String upazila}) {
    unions.clear();
    //selectedUnion.value = "";
    final selectedDist = bdDataModel.value.divisions
        ?.firstWhereOrNull((d) => d.name == selectedDivision.value)
        ?.districts
        ?.firstWhereOrNull((dist) => dist.name == selectedDistrict.value);
    if (selectedDist != null) {
      for (var upa in selectedDist.upazilas ?? []) {
        if (upa is Map<String, dynamic> && upa["name"] == upazila) {
          List<dynamic>? unionList = upa["unions"];
          if (unionList != null) {
            for (var unionName in unionList) {
              unions.add(unionName.toString());
            }
          }
          break; // Found the upazila, no need to continue loop
        }
      }
    }
  }


  Future<void> placeOrder() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.placeOrder;

    // 1️⃣ Cart items from CartController
    final cartController = Get.find<CartController>();
    var items = <Map<String, dynamic>>[];
    for (int i = 0; i < cartController.cartItems.length; i++) {
      final c = cartController.cartItems[i];
      items.add({
        "product_id": c.productId,
        "product_name": c.title,
        "quantity": c.quantity.toString(),
        "color":c.color,
        "size":c.size,
        "unit_price": c.afterDiscountPrice?? c.price.toStringAsFixed(2),
        "total_price":(c.afterDiscountPrice??"").isEmpty
            ? (c.price * c.quantity).toStringAsFixed(2)
            :((double.tryParse(c.afterDiscountPrice??"0")??0) * c.quantity).toStringAsFixed(2),
      });
    }

    // 2️⃣ Shipping address
    var shippingAddress = {
      "full_name": nameController.text,
      "phone_no": "+${selectedPhoneCountry.value.callingCode??''}${phoneController.text}",
      "division": selectedDivision.value,
      "district": selectedDistrict.value,
      "thana": upazilaController.text,//selectedUpazila.value,
      "union": "",//selectedUnion.value,
      "street_address": streetAddressController.text,
    };

    // 4️⃣ Flatten nested body for form-data
    var body = {
      //"user_id": "5",
      "subtotal": subtotal.value.toStringAsFixed(2),
      "discount": discountTotal.value.toStringAsFixed(2),
      "delivery_charge": deliveryCharge.value.toStringAsFixed(2),
      "total": total.value.toStringAsFixed(2),
      "payment_method": "Cash on Delivery",
    };

    // Add items with index for form-data


    // Add shipping_address keys
    shippingAddress.forEach((key, value) {
     // body["shipping_address[$key]"] = value.toString();
      body[key] = value.toString();
    });

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      body["items[$i][product_id]"] = item["product_id"];
      // body["items[$i][product_name]"] = item["product_name"];
      body["items[$i][quantity]"] = item["quantity"];
      body["items[$i][unit_price]"] = item["unit_price"].toString();
      body["items[$i][color]"] = item["color"].toString();
      body["items[$i][size]"] = item["size"].toString();

      // body["items[$i][total_price]"] = item["total_price"].toString();
    }

    // 5️⃣ Send request

    try {

      var res=await RemoteServices.postRequest(endpoint: endpoint,body: body);
      if(res!=null){

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"]
        ).showSnackBar();

        Get.find<CartController>().clearCart();
        Get.offAndToNamed(
          Routes.ORDER_DETAILS,
          arguments: {"orderId": res["data"]["id"].toString()},
        );

      }else{
       CustomSnackBar(
         isSuccess: false,
         msg: APIEndPoints.httpErrorMSG.value
       ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }

  }


  void getOrderSummary(){


    // Calculate subtotal and discount


    for (var item in cartController.cartItems) {
      double itemPrice = item.price;
      double discountedPrice =
          double.tryParse(item.afterDiscountPrice ?? '') ?? item.price;
      int quantity = item.quantity;

      subtotal.value += itemPrice * quantity;
      discountTotal.value += (itemPrice - discountedPrice) * quantity;
    }

     total.value = (subtotal.value - discountTotal.value) + deliveryCharge.value;

    print(total);
  }

 Future<void> getDeliveryCharge() async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getDeliveryCharge;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
        deliveryCharge.value=double.tryParse((res["data"]??"0").toString())??0.0;

      }
    } finally {
      isLoading.value=false;
    }
 }


 Future<void> getSavedDeliveryAddress() async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getSavedDeliveryAddress;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
       LastShippingAddressModel lastShippingAddressModel=LastShippingAddressModel.fromJson(res);
       savedShippingAddress.value=lastShippingAddressModel.data??ShippingAddressData();
      }
      setShippingAddress();
    } finally {
      isLoading.value=false;
    }
 }

  void setShippingAddress() async {
    final saved = savedShippingAddress.value;

    // ✅ If saved address exists, use that — otherwise use userData
    final fullName = saved.id != null ? saved.fullName : userData.value.name;
    final fullPhone = saved.id != null ? saved.phoneNo : userData.value.mobile;
    final division = saved.id != null ? saved.division : "";
    final district = saved.id != null ? saved.district : "";
    final thana = saved.id != null ? saved.thana : "";
    final street = saved.id != null ? saved.streetAddress : userData.value.address;

    // ✅ Set name
    nameController.text = fullName ?? "";

    // ✅ Handle phone number parsing
    if (fullPhone != null && fullPhone.isNotEmpty) {
      final cleanPhone = fullPhone.replaceAll(RegExp(r'[^0-9+]'), '');

      final matchedCountry = countryList.firstWhereOrNull((country) {
        final code = country.callingCode ?? "";
        return cleanPhone.startsWith("+$code") || cleanPhone.startsWith(code);
      });

      if (matchedCountry != null) {
        selectedPhoneCountry.value = matchedCountry;

        final code = matchedCountry.callingCode ?? "";
        var localNumber = cleanPhone;

        if (localNumber.startsWith("+$code")) {
          localNumber = localNumber.substring(code.length + 1);
        } else if (localNumber.startsWith(code)) {
          localNumber = localNumber.substring(code.length);
        }
        phoneController.text = localNumber;
      } else {
        phoneController.text = cleanPhone;
      }
    } else {
      phoneController.clear();
    }

    // ✅ Division and District loading
    selectedDivision.value = division ?? "";
    if (selectedDivision.value.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
      loadDistricts(division: selectedDivision.value);

      await Future.delayed(Duration(milliseconds: 100));
      selectedDistrict.value = district ?? "";
    }

    // ✅ Thana & Street
    upazilaController.text = thana ?? "";
    streetAddressController.text = street ?? "";
  }





  void toggleDifferentAddress() {
    isDifferentAddress.value = !isDifferentAddress.value;

    if (isDifferentAddress.value) {
      // Clear form for new address
      nameController.clear();
      phoneController.clear();
      upazilaController.clear();
      streetAddressController.clear();
      selectedDivision.value = "";
      selectedDistrict.value = "";
    } else {
      setShippingAddress();
    }
  }




}
