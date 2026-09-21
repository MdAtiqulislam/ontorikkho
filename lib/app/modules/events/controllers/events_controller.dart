import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/eventDetails/controllers/event_details_controller.dart';
import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';
import '../../../../models/pagination_model.dart';

class EventsController extends GetxController with ScrollLoadMoreMixin {
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore=false.obs;

  var upcomingPagination = Pagination().obs;
  var ongoingPagination = Pagination().obs;
  var expiredPagination = Pagination().obs;

  var upcomingEvents = <SingleEvent>[].obs;
  var ongoingEvents = <SingleEvent>[].obs;
  var expiredEvents = <SingleEvent>[].obs;

  var favouriteEvents=<SingleEvent>[].obs;


  final ScrollController scrollController=ScrollController();

  @override
  void onInit() {
    super.onInit();
    _getEventData();
    _getFavouriteEvent();

  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
      //nextPageUrl: expiredPagination.value.nextPageUrl,
      onLoadMore: () {
        final url = expiredPagination.value.nextPageUrl;
        if (url != null) {
          loadMore(url: url);
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _getEventData() async {
    isLoading.value = true;
    try {
      final rs = await RemoteServices.getRequest(endpoint: APIEndPoints.getEvents);
      if (rs != null) {
        final eventListModel = EventListModel.fromJson(rs);

        // Upcoming events
        upcomingEvents.value = eventListModel.data?.upcommingEvents ?? [];

        // Ongoing events
        ongoingEvents.value = eventListModel.data?.ongoingEvents ?? [];

        // Expired events
        expiredEvents.value = eventListModel.data?.expiredEvents ?? [];

        // Pagination for expired
        upcomingPagination.value = eventListModel.pagination?.upcomming ?? Pagination();
        ongoingPagination.value = eventListModel.pagination?.ongoing ?? Pagination();
        expiredPagination.value = eventListModel.pagination?.expired ?? Pagination();
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



  Future<void> loadMore({required String url}) async {
    isLoadingMore.value = true;

    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);

      if (rs != null) {
        final eventListModel = EventListModel.fromJson(rs);

        // Update pagination model
        if (eventListModel.pagination?.expired != null) {
          expiredPagination.value = eventListModel.pagination?.expired??Pagination();
        }

        // Add to ExpiredEvents
        if (eventListModel.data?.expiredEvents != null) {
          expiredEvents.addAll(eventListModel.data!.expiredEvents!);
        }

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMore.value = false;
    }
  }

  void joinEvent(SingleEvent event)async {
    isUpdating.value=true;
    var body={"event_id":event.id.toString()};
    var endpoint=APIEndPoints.joinEvent;
    try {
      var rs=await RemoteServices.postRequest(endpoint: endpoint,body: body);
      if(rs!=null){
        CustomSnackBar(
          isSuccess: true,
          msg: rs["msg"]
        ).showSnackBar();
      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
   isUpdating.value=false;
    }
  }

  Future<void> _getFavouriteEvent() async{
    favouriteEvents.value=await LocalServices.getFavouriteEvents();
  }

  Future<void> addOrUpdateFavouriteEvent({required SingleEvent event}) async{
    await LocalServices.addOrUpdateFavouriteEvent(event);
    await _getFavouriteEvent();
    refresh();
  }

  void getDetails({required SingleEvent event}) {
    Get.put(EventDetailsController()).getDetails(id:event.id.toString());
    Get.toNamed(Routes.EVENT_DETAILS);
  }
}

