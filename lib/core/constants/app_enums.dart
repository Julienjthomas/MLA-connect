import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum FeatureType { report, appreciate, idea, improve }

extension FeatureTypeX on FeatureType {
  Color get color => switch (this) {
        FeatureType.report => AppColors.reportOrange,
        FeatureType.appreciate => AppColors.appreciateGreen,
        FeatureType.idea => AppColors.ideaPurple,
        FeatureType.improve => AppColors.improveBlue,
      };

  Color get lightColor => switch (this) {
        FeatureType.report => AppColors.reportOrangeLight,
        FeatureType.appreciate => AppColors.appreciateGreenLight,
        FeatureType.idea => AppColors.ideaPurpleLight,
        FeatureType.improve => AppColors.improveBlueLight,
      };

  String get label => switch (this) {
        FeatureType.report => 'Report Problem',
        FeatureType.appreciate => 'Appreciate',
        FeatureType.idea => 'Share Idea',
        FeatureType.improve => 'Suggest Improvement',
      };

  String get subtitle => switch (this) {
        FeatureType.report => 'Roads, water, waste, safety & public issues',
        FeatureType.appreciate => 'Recognize good work, staff or projects',
        FeatureType.idea => 'Big ideas for the future of our constituency',
        FeatureType.improve => 'Practical improvements for a better future',
      };

  IconData get icon => switch (this) {
        FeatureType.report => Icons.warning_amber_rounded,
        FeatureType.appreciate => Icons.favorite_rounded,
        FeatureType.idea => Icons.lightbulb_rounded,
        FeatureType.improve => Icons.rocket_launch_rounded,
      };
}

enum SubmissionStatus { submitted, underReview, assigned, inProgress, resolved, rejected }

extension SubmissionStatusX on SubmissionStatus {
  String get label => switch (this) {
        SubmissionStatus.submitted => 'Submitted',
        SubmissionStatus.underReview => 'Under Review',
        SubmissionStatus.assigned => 'Assigned',
        SubmissionStatus.inProgress => 'In Progress',
        SubmissionStatus.resolved => 'Resolved',
        SubmissionStatus.rejected => 'Rejected',
      };

  Color get color => switch (this) {
        SubmissionStatus.submitted => AppColors.statusSubmitted,
        SubmissionStatus.underReview => AppColors.statusUnderReview,
        SubmissionStatus.assigned => AppColors.statusAssigned,
        SubmissionStatus.inProgress => AppColors.statusInProgress,
        SubmissionStatus.resolved => AppColors.statusResolved,
        SubmissionStatus.rejected => AppColors.statusRejected,
      };

  Color get bgColor => switch (this) {
        SubmissionStatus.submitted => AppColors.statusSubmittedBg,
        SubmissionStatus.underReview => AppColors.statusUnderReviewBg,
        SubmissionStatus.assigned => AppColors.statusAssignedBg,
        SubmissionStatus.inProgress => AppColors.statusInProgressBg,
        SubmissionStatus.resolved => AppColors.statusResolvedBg,
        SubmissionStatus.rejected => AppColors.statusRejectedBg,
      };

  static SubmissionStatus fromString(String s) => switch (s) {
        'under_review' => SubmissionStatus.underReview,
        'assigned' => SubmissionStatus.assigned,
        'in_progress' => SubmissionStatus.inProgress,
        'resolved' => SubmissionStatus.resolved,
        'rejected' => SubmissionStatus.rejected,
        _ => SubmissionStatus.submitted,
      };

  String get dbValue => switch (this) {
        SubmissionStatus.submitted => 'submitted',
        SubmissionStatus.underReview => 'under_review',
        SubmissionStatus.assigned => 'assigned',
        SubmissionStatus.inProgress => 'in_progress',
        SubmissionStatus.resolved => 'resolved',
        SubmissionStatus.rejected => 'rejected',
      };
}

enum ReportCategory {
  road,
  water,
  electricity,
  streetlight,
  drainage,
  waste,
  safety,
  other,
}

extension ReportCategoryX on ReportCategory {
  String get label => switch (this) {
        ReportCategory.road => 'Road Damage',
        ReportCategory.water => 'Water Supply',
        ReportCategory.electricity => 'Electricity',
        ReportCategory.streetlight => 'Street Light',
        ReportCategory.drainage => 'Drainage',
        ReportCategory.waste => 'Waste Management',
        ReportCategory.safety => 'Public Safety',
        ReportCategory.other => 'Other',
      };

  IconData get icon => switch (this) {
        ReportCategory.road => Icons.add_road,
        ReportCategory.water => Icons.water_drop_outlined,
        ReportCategory.electricity => Icons.electric_bolt_outlined,
        ReportCategory.streetlight => Icons.light_outlined,
        ReportCategory.drainage => Icons.water_outlined,
        ReportCategory.waste => Icons.delete_outline,
        ReportCategory.safety => Icons.shield_outlined,
        ReportCategory.other => Icons.help_outline,
      };

  String get dbValue => name;

  static ReportCategory fromString(String s) =>
      ReportCategory.values.firstWhere((e) => e.name == s, orElse: () => ReportCategory.other);
}

enum SubmissionVisibility { public, mlaOnly, anonymous }

extension SubmissionVisibilityX on SubmissionVisibility {
  String get label => switch (this) {
        SubmissionVisibility.public => 'Public Wall',
        SubmissionVisibility.mlaOnly => 'MLA Office Only',
        SubmissionVisibility.anonymous => 'Anonymous',
      };

  String get description => switch (this) {
        SubmissionVisibility.public => 'Visible to everyone on the platform',
        SubmissionVisibility.mlaOnly => 'Only MLA office can view this',
        SubmissionVisibility.anonymous => 'Your name will be hidden',
      };

  String get dbValue => name;
}

enum UpdateCategory { all, development, events, resolved, announcements }

extension UpdateCategoryX on UpdateCategory {
  String get label => switch (this) {
        UpdateCategory.all => 'All',
        UpdateCategory.development => 'Development',
        UpdateCategory.events => 'Events',
        UpdateCategory.resolved => 'Resolved Issues',
        UpdateCategory.announcements => 'Announcements',
      };

  Color get color => switch (this) {
        UpdateCategory.development => AppColors.improveBlue,
        UpdateCategory.events => AppColors.ideaPurple,
        UpdateCategory.resolved => AppColors.appreciateGreen,
        UpdateCategory.announcements => AppColors.reportOrange,
        _ => AppColors.grey500,
      };

  static UpdateCategory fromString(String s) => switch (s) {
        'development' => UpdateCategory.development,
        'events' => UpdateCategory.events,
        'resolved' => UpdateCategory.resolved,
        'announcements' => UpdateCategory.announcements,
        _ => UpdateCategory.all,
      };
}

enum ActivityTab { reports, ideas, appreciations, saved }

extension ActivityTabX on ActivityTab {
  String get label => switch (this) {
        ActivityTab.reports => 'Reports',
        ActivityTab.ideas => 'Ideas',
        ActivityTab.appreciations => 'Appreciations',
        ActivityTab.saved => 'Saved',
      };
}
