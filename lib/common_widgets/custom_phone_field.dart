/*


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import '../models/country_list_model.dart';

class CustomPhoneTextField extends StatefulWidget {
  final String? title;
  final bool isRequired;
  final TextEditingController? controller;
  final String callingCode;
  final Function(SingleCountry)? onChange;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? titlePadding;

  // ✅ NEW: Accept selectedCountry from parent
  final SingleCountry? selectedCountry;

  const CustomPhoneTextField({
    this.controller,
    required this.callingCode,
    this.onChange,
    this.title,
    this.isRequired = false,
    this.validator,
    this.titlePadding,
    this.selectedCountry, // ✅ NEW
    super.key,
  });

  @override
  State<CustomPhoneTextField> createState() => _CustomPhoneTextFieldState();
}

class _CustomPhoneTextFieldState extends State<CustomPhoneTextField> {
  String? errorText;
  SingleCountry? selectedCountry;
  List<SingleCountry> countryList = [];

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry; // ✅ Set initial selected country
    _loadCountryList();
  }

  @override
  Widget build(BuildContext context) {
    final maxLen = selectedCountry?.maxPhoneNumberLength ?? 10;
    final controller = widget.controller ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: widget.titlePadding ?? EdgeInsets.zero,
            child: Row(
              children: [
                HeaderText(text: widget.title!, size: 12),
                if (widget.isRequired)
                  HeaderText(text: " *", color: Colors.red, size: 12),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inactiveColor),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          ),
          child: Row(
            children: [
              Expanded(flex: 47, child: _buildCountryDropdown()),
              Expanded(
                flex: 53,
                child: TextFormField(
                  controller: controller,
                  maxLength: maxLen,
                  buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) =>
                  const SizedBox.shrink(),
                  validator: widget.validator ?? (value) => _validate(value),
                  onFieldSubmitted: (val) {
                    final validation = _validate(val);
                    setState(() => errorText = validation);
                  },
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    contentPadding: EdgeInsets.all(12),
                    hintStyle: TextStyle(fontSize: 14.sp),
                    enabledBorder: _outlineBorder(color: AppColors.inactiveColor),
                    focusedBorder: _outlineBorder(
                      color: errorText != null ? AppColors.dangerColor : AppColors.mutedText,
                    ),
                    errorBorder: _outlineBorder(color: AppColors.dangerColor),
                    border: _outlineBorder(color: AppColors.inactiveColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "      ${errorText ?? ""}",
              style: TextStyle(
                color: AppColors.dangerColor,
                fontSize: 11.sp,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _outlineBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(5.r),
        bottomRight: Radius.circular(5.r),
      ),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: DropdownSearch<SingleCountry>(
        items: (filter, _) => countryList,
        selectedItem: selectedCountry,
        onChanged: (value) {
          setState(() {
            selectedCountry = value;
          });
          widget.onChange?.call(value!);
        },
        filterFn: (country, filter) => _filterCountries(country, filter),
        dropdownBuilder: _dropdownBuilder,
        itemAsString: (country) => country.iso31662 ?? "",
        compareFn: (a, b) => a.iso31662 == b.iso31662,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
              hintText: "Search...",
              hintStyle: TextStyle(fontSize: 12.sp),
            ),
          ),
          itemBuilder: _buildPopupItem,
          listViewProps: const ListViewProps(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
          ),
        ),
        decoratorProps: _buildDecoratorProps(),
      ),
    );
  }

  bool _filterCountries(SingleCountry country, String filter) {
    final query = filter.toLowerCase();
    return (country.name?.toLowerCase().contains(query) ?? false) ||
        (country.iso31662?.toLowerCase().contains(query) ?? false);
  }

  Widget _dropdownBuilder(BuildContext context, SingleCountry? country) {
    if (country?.name == null) {
      return Text(
        "Choose Country*",
        maxLines: 1,
        style: TextStyle(
          color: AppColors.mutedText,
          fontSize: 10.sp,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      );
    }

    final flagUrl = country?.flagUrl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (flagUrl != null && flagUrl.isNotEmpty)
          Container(
            height: 15.sp,
            width: 30.sp,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.rectangle),
            child: SvgPicture.asset(
              flagUrl,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => const Icon(Icons.flag, size: 20),
            ),
          ),
        SizedBox(width: AppDimensions.contentPadding.w),
        Expanded(
          child: HeaderText(
            text: "+${country?.callingCode ?? ""}",
            size: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  DropDownDecoratorProps _buildDecoratorProps() {
    return DropDownDecoratorProps(
      decoration: InputDecoration(
        suffixIconColor: AppColors.primaryColor,
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.only(
          left: AppDimensions.contentPadding,
          top: AppDimensions.verticalPadding,
          bottom: AppDimensions.verticalPadding,
        ),
      ),
    );
  }

  Widget _buildPopupItem(
      BuildContext context,
      SingleCountry country,
      bool isSelected,
      _,
      )
  {
    final flagUrl = country.flagUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            country.name ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.bodyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (flagUrl != null && flagUrl.isNotEmpty)
                SvgPicture.asset(
                  flagUrl,
                  height: 20,
                  width: 30,
                  placeholderBuilder: (_) => const Icon(Icons.flag, size: 20),
                ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  country.iso31662 ?? "",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.bodyText),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    if (widget.isRequired) {
      if (value == null || value.trim().isEmpty) {
        setState(() => errorText = "This field is required");
        return null;
      }

      final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

      if (digitsOnly.length < 7) {
        setState(() => errorText = "Enter a valid phone number");
        return null;
      }

      if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
        setState(() => errorText = "Phone number must contain digits only");
        return null;
      }

      if (selectedCountry != null &&
          digitsOnly.length > (selectedCountry?.maxPhoneNumberLength ?? 0)) {
        setState(() => errorText = "Too long for selected country");
        return null;
      }
    }

    setState(() => errorText = null);
    return null;
  }

  Future<void> _loadCountryList() async {
    final String response = await rootBundle.loadString(
      'assets/data/countries_with_phone_length.json',
    );
    final CountryListModel countryModel = countryListModelFromJson(response);
    setState(() {
      countryList = countryModel.data ?? [];

      // Optional: If no selectedCountry passed but calling code matches, set default
      if (selectedCountry == null && widget.callingCode.isNotEmpty) {
        selectedCountry = countryList.firstWhere(
              (c) => "+${c.callingCode}" == widget.callingCode,
          orElse: () => countryList.first,
        );
      }
    });
  }
}
*/


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import '../models/country_list_model.dart';

class CustomPhoneTextField extends StatefulWidget {
  final String? title;
  final bool isRequired;
  final TextEditingController? controller;
  final String callingCode;
  final Function(SingleCountry)? onChange;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? titlePadding;
  final SingleCountry? selectedCountry;

  const CustomPhoneTextField({
    this.controller,
    required this.callingCode,
    this.onChange,
    this.title,
    this.isRequired = false,
    this.validator,
    this.titlePadding,
    this.selectedCountry,
    super.key,
  });

  @override
  State<CustomPhoneTextField> createState() => _CustomPhoneTextFieldState();
}

class _CustomPhoneTextFieldState extends State<CustomPhoneTextField> {
  String? errorText;
  SingleCountry? selectedCountry;
  List<SingleCountry> countryList = [];

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry;
    _loadCountryList();
  }

  @override
  Widget build(BuildContext context) {
    final maxLen = selectedCountry?.maxPhoneNumberLength ?? 10;
    final controller = widget.controller ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: widget.titlePadding ?? EdgeInsets.zero,
            child: Row(
              children: [
                HeaderText(text: widget.title!, size: 12),
                if (widget.isRequired)
                  HeaderText(text: " *", color: Colors.red, size: 12),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inactiveColor),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          ),
          child: Row(
            children: [
              Expanded(flex: 47, child: _buildCountryDropdown()),
              Expanded(
                flex: 53,
                child: TextFormField(
                  controller: controller,
                  maxLength: maxLen,
                  buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) =>
                  const SizedBox.shrink(),
                  validator: widget.validator ?? (value) => _validate(value),
                  onFieldSubmitted: (val) {
                    final validation = _validate(val);
                    if (!mounted) return;
                    setState(() => errorText = validation);
                  },
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    contentPadding: EdgeInsets.all(12),
                    hintStyle: TextStyle(fontSize: 14.sp),
                    enabledBorder: _outlineBorder(color: AppColors.inactiveColor),
                    focusedBorder: _outlineBorder(
                      color: errorText != null ? AppColors.dangerColor : AppColors.mutedText,
                    ),
                    errorBorder: _outlineBorder(color: AppColors.dangerColor),
                    border: _outlineBorder(color: AppColors.inactiveColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "      ${errorText ?? ""}",
              style: TextStyle(
                color: AppColors.dangerColor,
                fontSize: 11.sp,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _outlineBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(5.r),
        bottomRight: Radius.circular(5.r),
      ),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: DropdownSearch<SingleCountry>(
        items: (filter, _) => countryList,
        selectedItem: selectedCountry,
        onChanged: (value) {
          if (!mounted) return;
          setState(() {
            selectedCountry = value;
          });
          if (value != null) widget.onChange?.call(value);
        },
        filterFn: (country, filter) => _filterCountries(country, filter),
        dropdownBuilder: _dropdownBuilder,
        itemAsString: (country) => country.iso31662 ?? "",
        compareFn: (a, b) => a.iso31662 == b.iso31662,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
              hintText: "Search...",
              hintStyle: TextStyle(fontSize: 12.sp),
            ),
          ),
          itemBuilder: _buildPopupItem,
          listViewProps: const ListViewProps(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
          ),
        ),
        decoratorProps: _buildDecoratorProps(),
      ),
    );
  }

  bool _filterCountries(SingleCountry country, String filter) {
    final query = filter.toLowerCase();
    return (country.name?.toLowerCase().contains(query) ?? false) ||
        (country.iso31662?.toLowerCase().contains(query) ?? false);
  }

  Widget _dropdownBuilder(BuildContext context, SingleCountry? country) {
    if (country?.name == null) {
      return Text(
        "Choose Country*",
        maxLines: 1,
        style: TextStyle(
          color: AppColors.mutedText,
          fontSize: 10.sp,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      );
    }

    final flagUrl = country?.flagUrl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (flagUrl != null && flagUrl.isNotEmpty)
          Container(
            height: 15.sp,
            width: 30.sp,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.rectangle),
            child: SvgPicture.asset(
              flagUrl,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => const Icon(Icons.flag, size: 20),
            ),
          ),
        SizedBox(width: AppDimensions.contentPadding.w),
        Expanded(
          child: HeaderText(
            text: "+${country?.callingCode ?? ""}",
            size: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  DropDownDecoratorProps _buildDecoratorProps() {
    return DropDownDecoratorProps(
      decoration: InputDecoration(
        suffixIconColor: AppColors.primaryColor,
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.only(
          left: AppDimensions.contentPadding,
          top: AppDimensions.verticalPadding,
          bottom: AppDimensions.verticalPadding,
        ),
      ),
    );
  }

  Widget _buildPopupItem(
      BuildContext context,
      SingleCountry country,
      bool isSelected,
      _,
      ) {
    final flagUrl = country.flagUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            country.name ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.bodyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (flagUrl != null && flagUrl.isNotEmpty)
                SvgPicture.asset(
                  flagUrl,
                  height: 20,
                  width: 30,
                  placeholderBuilder: (_) => const Icon(Icons.flag, size: 20),
                ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  country.iso31662 ?? "",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.bodyText),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    if (widget.isRequired) {
      if (value == null || value.trim().isEmpty) {
        if (!mounted) return null;
        setState(() => errorText = "This field is required");
        return null;
      }

      final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

      if (digitsOnly.length < 7) {
        if (!mounted) return null;
        setState(() => errorText = "Enter a valid phone number");
        return null;
      }

      if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
        if (!mounted) return null;
        setState(() => errorText = "Phone number must contain digits only");
        return null;
      }

      if (selectedCountry != null &&
          digitsOnly.length > (selectedCountry?.maxPhoneNumberLength ?? 0)) {
        if (!mounted) return null;
        setState(() => errorText = "Too long for selected country");
        return null;
      }
    }

    if (!mounted) return null;
    setState(() => errorText = null);
    return null;
  }

  Future<void> _loadCountryList() async {
    final String response = await rootBundle.loadString(
      'assets/data/countries_with_phone_length.json',
    );
    final CountryListModel countryModel = countryListModelFromJson(response);

    if (!mounted) return;

    setState(() {
      countryList = countryModel.data ?? [];

      if (selectedCountry == null && widget.callingCode.isNotEmpty) {
        selectedCountry = countryList.firstWhere(
              (c) => "+${c.callingCode}" == widget.callingCode,
          orElse: () => countryList.first,
        );
      }
    });
  }
}
