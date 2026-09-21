import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/pages/models/recommended_pages_model.dart';
import 'package:ontorikkho/app/modules/pages/widgets/page_action_button.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/overlapping_avater.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../theme/widget_theme/custom_text_theme.dart';
import '../../../../utils/enums.dart';
import '../models/page_model.dart';
class PageListItem extends StatelessWidget {
  final PageModel pageItem;
  final VoidCallback? onDetails;
  final Function(PageActionType action,String pageId)? onActionTap;

  const PageListItem({
    required this.pageItem,
    this.onDetails,
    this.onActionTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
      child: InkWell(
        onTap: onDetails,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Avatar
            CustomCircleAvatar(
              image: pageItem.page?.profileImage ?? "",
              width: 70.r,
              height: 70.r,
              border: 5,
              bgColor: AppColors.primaryColor.withAlpha(30),
            ),
            SizedBox(width: AppDimensions.widgetPadding.w),

            /// 📄 Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    pageItem.page?.name ?? "",
                    style: AppTextStyles.header(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: AppDimensions.contentPadding.h),

                  /// Mutual Friends
                  if ((pageItem.mutualMembers).isNotEmpty)
                    Row(
                      children: [
                        OverlappingAvatars(
                            items: pageItem.mutualMembers,
                            imageBuilder: (e) => e.avatar ?? ""
                        ),

                        //_mutualAvatars(),
                        SizedBox(width: AppDimensions.contentPadding.w),
                        Expanded(
                          child: Text(
                            "${(pageItem.followerCount??0).kmB} follow this.",
                            style: AppTextStyles.body(),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: AppDimensions.contentPadding.h),
                  PageActionButtons(
                    status: PageStatusExtension.fromString(
                      pageItem.page?.pageStatus,
                    ),
                    pageId: pageItem.page?.id.toString() ?? "",
                    onActionTap: ({
                      required action,
                      required pageId,
                    }){
                     onActionTap?.call(action,pageId);
                    },
                  )
                 //need to add buttons here
                 // _buildButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
