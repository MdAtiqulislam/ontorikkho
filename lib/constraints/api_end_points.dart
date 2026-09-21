import 'package:get/get.dart';

class APIEndPoints{
  static const baseURL = "https://members.ontorikkho.com";
  //static const baseURL = "https://api.clubsuite.app";
  static var httpErrorMSG = "".obs;
  static const generalHttpErrorMSG = "An unexpected error occurred while processing your request. Please try again later.";

  static const login="/api/login";
  static const getStore="api/v1/stores";
  static const getProduct="api/v1/products";
  static const getInventories="v1/store-products";
  static const resetPasswordOTP="/api/fpw-email-verify";
  static const verifyResetPasswordOTP="/api/fpw-otp-verify";
  static const resetPassword="/api/reset-pw-confirmation";
  static const getSignUpOtherInfo="/api/get-signup-others-info";
  static const getReferenceMemberList="/api/reference_member_list";
  static const registration="/api/registration";
  static const registrationOTPVerification="/api/verify-otp";
  static const getEvents="/api/ajax/events_list_v2";
  static const joinEvent="/api/ajax/join_event";
  static const eventDetails="/api/ajax/event_details";
  static const partners="/api/ajax/club_partners";
  static const memberDirectories="/api/ajax/member_directory";
  static const products="/api/ajax/product_list";
  static const productDetails="/api/ajax/product_details";
  static const getImages="/api/ajax/photo_gallery";
  static const homeData="/api/ajax/home_data_v2";
  static const generalAnnouncements="/api/ajax/general_announcements_and_news";
  static const urgentAnnouncements="/api/ajax/urgent_notice_announcements_and_news";
  static const getUserData="/api/ajax/get_user_data";
  static const updateUserData="/api/ajax/update_profile";
  static const pendingList="/api/ajax/approval_request_pending_list";
  static const faq="/api/ajax/faq";
  static const privacyPolicy="/api/ajax/privacy_policy";
  static const pendingUserApproval="/api/ajax/pending_user_approved";
  static const getVideos="/api/ajax/video_gallery";
  static const placeOrder="/api/ajax/place_order";
  static const getOrderDetails="/api/ajax/order_details";
  static const getDeliveryCharge="/api/ajax/get_delivery_charge";
  static const orderHistory="/api/ajax/order_history";
  static const signupWithEmail="/api/otp-signup";
  static const signupWithEmailOtpVerify="/api/validate-signup-otp";
  static const setPassword="/api/otp-signup-set-password";
  static const completeSubscription="/api/membership-signup";
  static const getMissingDocuments="/api/ajax/member_missing_documents";
  static const uploadMissingDocuments="/api/ajax/update_member_missing_documents";
  static const getSavedDeliveryAddress="/api/ajax/member_last_shipping_address";
  static const getSupport="/api/ajax/contact_us";
  static const getMembershipPlans="/api/ajax/get_all_packages";
  static const upgradePlan="/api/ajax/upgrade_package";
  static const getCurrentPlan="/api/ajax/get_current_package";
  static const addToCart="/api/ajax/store_cart";
  static const incrementCart="/api/ajax/increment_cart";
  static const decrementCart="/api/ajax/decrement_cart";
  static const removeCart="/api/ajax/remove_cart";
  static const getCartData="/api/ajax/get_cart_data";
  static const versionCheck="/api/app-version";
  static const inviteFriend="/api/ajax/invite_friends";
  static const get2faStatus="/api/ajax/member_2fa_status_check";
  static const twoFaStatusUpdate="/api/ajax/member_2fa_status_update";
  static const getOTP2faVerify="/api/ajax/get_otp_2fa_verify";
  static const verify2faOTP="/api/ajax/verify_2fa_code";
  static const getGoogle2FASetup="/api/ajax/google_2fa_setup";
  static const verifyGoogle2FA="/api/ajax/google_verify_otp";
  static const google2FAEnable="/api/ajax/google_2fa_enable";
  static var storeDeviceToken="/api/ajax/device_token_update";
  static var socialLoginEndpoint="/api/social-login";

  static var getPosts="/api/ajax/posts_list";
  static var getPostById="/api/ajax/post_show";

  static var getComments="/api/ajax/comments_list";

  static String removeReaction="/api/ajax/post_reaction_delete";

  static String addReaction="/api/ajax/post_reaction_create";

  static String updateReaction="/api/ajax/post_reaction_update";

  static var createPost="/api/ajax/post_create";

  static var deletePost="/api/ajax/post_delete";

  static var updatePost="/api/ajax/post_update";

  static var addComment="/api/ajax/comment_create";

  static var deleteComment="/api/ajax/comment_delete";
  static var deleteReply="/api/ajax/reply_delete";

  static var updateReply="/api/ajax/reply_update";
  static var updateComment="/api/ajax/comment_update";
  static var addReply="/api/ajax/reply_create";

  static var getNotification="/api/ajax/notifications_list";

  static var markNotificationAsRead="/api/ajax/mark_notification_read";

  static var deleteNotificationById="/api/ajax/delete_single_notification";

  static var deleteAllNotifications="/api/ajax/delete_all_notifications";

  static const deleteReadNotifications="/api/ajax/delete_read_notifications";

  static const getPostByIdAndComment="/api/ajax/post_with_comments";

  static const profileFeed="/api/ajax/profile_feed";

  static const updateProfilePhoto="/api/ajax/update_profile_picture";

  static const updateCoverPhoto="/api/ajax/update_cover_photo";

  static const getFriendSuggestions="/api/ajax/friends_suggestions";
  static const getFriendRequestIncoming="/api/ajax/friends_requests_incoming";
  static const getFriendRequestSent="/api/ajax/friends_requests_sent";

  static const confirmFriendRequest="/api/ajax/friends_request_accept";

  static const rejectFriendRequest="/api/ajax/friends_request_reject";

  static const addFriendRequest="/api/ajax/friends_request";

  static const cancelFriendRequest="/api/ajax/friends_request_cancel";

  static const removeFriendRequestSuggestion="/api/ajax/friends_suggestion_dismiss";

  static const blockUser="/api/ajax/friends_block";

  static const unblockUser="/api/ajax/friends_unblock";

  static const searchFriends="/api/ajax/friends_search";

  static const getMyFriends="/api/ajax/friends";

  static const unfriendUser="/api/ajax/friends_unfriend";

  static const getRecommendedPages="/api/ajax/get_recommended_pages";

  static const getInvitedPages="/api/ajax/get_invitations";

  static const getFollowingPages="/api/ajax/get_following_pages";

  static const getMyPages="/api/ajax/get_my_pages";

  static const getPageDetails="/api/ajax/get_page";

  static const getPageImages="/api/ajax/get_page_images";

  static const getPageVideos="/api/ajax/get_page_videos";

  static const updatePageProfilePhoto="/api/ajax/pages_update_profile_picture";

  static const  updatePageCoverPhoto="/api/ajax/pages_update_cover_photo";

  static const createPagePost="/api/ajax/pages_post_create";

  static const getPageCategories="/api/ajax/get_page_categories";

  static const createPage="/api/ajax/pages_create";

  static const markAsFollow="/api/ajax/mark_as_follow";

  static const markAsUnfollow="/api/ajax/remove_from_follow";

  static const removePageFromFollow="/api/ajax/remove_from_follow";

  static const acceptPageInvitation="/api/ajax/page_invitation_accept";

  static String sentInvitation="/api/ajax/page_invite";

  static String deniedPageInvitation="/api/ajax/page_invitation_decline";

  static String blockPage="/api/ajax/pages_block";

  static String unblockPage="/api/ajax/page_unblock";

  static const getAdmins="/api/ajax/get_page_admins";

  static const searchFriendsForAdminRul="/api/ajax/search_friends_for_admin_rule";

  static const addAdmin="/api/ajax/pages_add_admin";

  static const removeAdmin="/api/ajax/page_remove_admin";

  static const deletePage="/api/ajax/pages_delete";

  static const searchPage="/api/ajax/search_page";

  static const postShare="/api/ajax/post_share";



  }