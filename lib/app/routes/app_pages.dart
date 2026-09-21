import 'package:get/get.dart';
import '../modules/FAQ/bindings/faq_binding.dart';
import '../modules/FAQ/views/faq_view.dart';
import '../modules/OTP/bindings/otp_binding.dart';
import '../modules/OTP/views/otp_view.dart';
import '../modules/Password/bindings/password_binding.dart';
import '../modules/Password/views/password_view.dart';
import '../modules/announcements/bindings/announcements_binding.dart';
import '../modules/announcements/views/announcements_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/createPost/bindings/create_post_binding.dart';
import '../modules/createPost/views/create_post_view.dart';
import '../modules/directory/bindings/directory_binding.dart';
import '../modules/directory/views/directory_view.dart';
import '../modules/editPost/bindings/edit_post_binding.dart';
import '../modules/editPost/views/edit_post_view.dart';
import '../modules/editProfile/bindings/edit_profile_binding.dart';
import '../modules/editProfile/views/edit_profile_view.dart';
import '../modules/eventDetails/bindings/event_details_binding.dart';
import '../modules/eventDetails/views/event_details_view.dart';
import '../modules/eventList/bindings/event_list_binding.dart';
import '../modules/eventList/views/event_list_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/favourite/bindings/favourite_binding.dart';
import '../modules/favourite/views/favourite_view.dart';
import '../modules/forYou/bindings/for_you_binding.dart';
import '../modules/forYou/views/for_you_view.dart';
import '../modules/forgotPassword/bindings/forgot_password_binding.dart';
import '../modules/forgotPassword/views/forgot_password_view.dart';
import '../modules/friends/bindings/friends_binding.dart';
import '../modules/friends/views/friends_view.dart';
import '../modules/googleAuthenticator/bindings/google_authenticator_binding.dart';
import '../modules/googleAuthenticator/views/google_authenticator_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/imageViewer/bindings/image_viewer_binding.dart';
import '../modules/imageViewer/views/image_viewer_view.dart';
import '../modules/inviteFriends/bindings/invite_friends_binding.dart';
import '../modules/inviteFriends/views/invite_friends_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/media/bindings/media_binding.dart';
import '../modules/media/views/media_view.dart';
import '../modules/memberProfile/bindings/profile_binding.dart';
import '../modules/memberProfile/views/member_profile_view.dart';
import '../modules/membershipPlans/bindings/membership_plans_binding.dart';
import '../modules/membershipPlans/views/membership_plans_view.dart';
import '../modules/membershipRenew/bindings/membership_renew_binding.dart';
import '../modules/membershipRenew/views/membership_renew_view.dart';
import '../modules/missingDocuments/bindings/missing_documents_binding.dart';
import '../modules/missingDocuments/views/missing_documents_view.dart';
import '../modules/notificationDetails/bindings/notification_details_binding.dart';
import '../modules/notificationDetails/views/notification_details_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/orderDetails/bindings/order_details_binding.dart';
import '../modules/orderDetails/views/order_details_view.dart';
import '../modules/orderHistory/bindings/order_history_binding.dart';
import '../modules/orderHistory/views/order_history_view.dart';
import '../modules/orderTrack/bindings/order_track_binding.dart';
import '../modules/orderTrack/views/order_track_view.dart';
import '../modules/ownProfile/bindings/own_profile_binding.dart';
import '../modules/ownProfile/views/own_profile_view.dart';
import '../modules/pageFeed/bindings/page_feed_binding.dart';
import '../modules/pageFeed/views/manage_admin_view.dart';
import '../modules/pageFeed/views/page_feed_view.dart';
import '../modules/pages/bindings/pages_binding.dart';
import '../modules/pages/views/pages_view.dart';
import '../modules/partner/bindings/partner_binding.dart';
import '../modules/partner/views/partner_view.dart';
import '../modules/paymentOptions/bindings/payment_options_binding.dart';
import '../modules/paymentOptions/views/payment_options_view.dart';
import '../modules/pendingList/bindings/pending_list_binding.dart';
import '../modules/pendingList/views/pending_list_view.dart';
import '../modules/privacy/bindings/privacy_binding.dart';
import '../modules/privacy/views/privacy_view.dart';
import '../modules/productDetails/bindings/product_details_binding.dart';
import '../modules/productDetails/views/product_details_view.dart';
import '../modules/profileFeed/bindings/profile_feed_binding.dart';
import '../modules/profileFeed/views/profile_feed_view.dart';
import '../modules/pushNotification/bindings/push_notification_binding.dart';
import '../modules/pushNotification/views/push_notification_view.dart';
import '../modules/referenceMemberList/bindings/reference_member_list_binding.dart';
import '../modules/referenceMemberList/views/reference_member_list_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/settingsAndSupport/bindings/settings_and_support_binding.dart';
import '../modules/settingsAndSupport/views/settings_and_support_view.dart';
import '../modules/singlePostView/bindings/single_post_view_binding.dart';
import '../modules/singlePostView/views/single_post_view_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';
import '../modules/store/bindings/store_binding.dart';
import '../modules/store/views/store_view.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscriprtion_view.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';
import '../modules/twoStepVerification/bindings/two_step_verification_binding.dart';
import '../modules/twoStepVerification/views/two_step_verification_view.dart';
import '../modules/userPersonalData/bindings/user_personal_data_binding.dart';
import '../modules/userPersonalData/views/user_personal_data_view.dart';
import '../modules/videoPlayer/bindings/video_player_binding.dart';
import '../modules/videoPlayer/views/video_player_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;
  // static const INITIAL = Routes.TWO_STEP_VERIFICATION;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD,
      page: () => PasswordView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const MemberProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => EventsView(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAILS,
      page: () => const EventDetailsView(),
      binding: EventDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PARTNER,
      page: () => const PartnerView(),
      binding: PartnerBinding(),
    ),
    GetPage(
      name: _Paths.DIRECTORY,
      page: () => const DirectoryView(),
      binding: DirectoryBinding(),
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MEDIA,
      page: () => const MediaView(),
      binding: MediaBinding(),
    ),
    GetPage(
      name: _Paths.OWN_PROFILE,
      page: () => OwnProfileView(),
      binding: OwnProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS_AND_SUPPORT,
      page: () => const SettingsAndSupportView(),
      binding: SettingsAndSupportBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY,
      page: () => const PrivacyView(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: _Paths.PUSH_NOTIFICATION,
      page: () => const PushNotificationView(),
      binding: PushNotificationBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_VIEWER,
      page: () => const ImageViewerView(),
      binding: ImageViewerBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PLAYER,
      page: () => const VideoPlayerView(),
      binding: VideoPlayerBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_OPTIONS,
      page: () => const PaymentOptionsView(),
      binding: PaymentOptionsBinding(),
    ),
    GetPage(
      name: _Paths.MEMBERSHIP_RENEW,
      page: () => const MembershipRenewView(),
      binding: MembershipRenewBinding(),
    ),
    GetPage(
      name: _Paths.FEVOURITE,
      page: () => const FavouriteView(),
      binding: FavouriteBinding(),
    ),
    GetPage(
      name: _Paths.ANNOUNCEMENTS,
      page: () => const AnnouncementsView(),
      binding: AnnouncementsBinding(),
    ),
    GetPage(
      name: _Paths.PENDING_LIST,
      page: () => const PendingListView(),
      binding: PendingListBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.REFERENCE_MEMBER_LIST,
      page: () => const ReferenceMemberListView(),
      binding: ReferenceMemberListBinding(),
    ),
    GetPage(
      name: _Paths.USER_PERSONAL_DATA,
      page: () => const UserPersonalDataView(),
      binding: UserPersonalDataBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPRTION,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.MISSING_DOCUMENTS,
      page: () => MissingDocumentsView(),
      binding: MissingDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_TRACK,
      page: () => const OrderTrackView(),
      binding: OrderTrackBinding(),
    ),
    GetPage(
      name: _Paths.MEMBERSHIP_PLANS,
      page: () => MembershipPlansView(),
      binding: MembershipPlansBinding(),
    ),
    GetPage(
      name: _Paths.INVITE_FRIENDS,
      page: () => const InviteFriendsView(),
      binding: InviteFriendsBinding(),
    ),
    GetPage(
      name: _Paths.TWO_STEP_VERIFICATION,
      page: () => const TwoStepVerificationView(),
      binding: TwoStepVerificationBinding(),
    ),
    GetPage(
      name: _Paths.GOOGLE_AUTHENTICATOR,
      page: () => const GoogleAuthenticatorView(),
      binding: GoogleAuthenticatorBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_LIST,
      page: () => const EventListView(),
      binding: EventListBinding(),
    ),
    GetPage(
      name: _Paths.FOR_YOU,
      page: () => const ForYouView(),
      binding: ForYouBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_POST,
      page: () => CreatePostView(),
      binding: CreatePostBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.SINGLE_POST_VIEW,
      page: () => const SinglePostViewView(),
      binding: SinglePostViewBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_POST,
      page: () => EditPostView(),
      binding: EditPostBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_FEED,
      page: () => ProfileFeedView(),
      binding: ProfileFeedBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_DETAILS,
      page: () => const NotificationDetailsView(),
      binding: NotificationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.FRIENDS,
      page: () => const FriendsView(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: _Paths.PAGES,
      page: () => const PagesView(),
      binding: PagesBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_FEED,
      page: () =>  PageFeedView(),
      binding: PageFeedBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_ADMIN_PAGE,
      page: () => const ManageAdminView(),
      binding: ManageAdminBinding(),
    ),
  ];
}
