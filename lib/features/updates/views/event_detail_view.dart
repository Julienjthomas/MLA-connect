import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/linkable_text.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/event_model.dart';
import '../../../data/remote/events_api.dart';
import '../../../data/services/event_service.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../controllers/updates_controller.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({super.key});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final _service = EventService();
  EventModel? _event;
  bool _loading = true;
  bool _interested = false;
  bool _showingInterest = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = Get.arguments as String?;
    EventModel? event;
    if (id != null && Get.isRegistered<UpdatesController>()) {
      event = Get.find<UpdatesController>().events.firstWhereOrNull((e) => e.id == id);
    }
    event ??= id != null ? await _service.getEvent(id) : null;
    if (!mounted) return;
    setState(() {
      _event = event;
      _loading = false;
    });
  }

  void _openFullImage(String url) {
    final event = _event;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullImageView(
          url: url,
          heroTag: event != null ? 'event_cover_${event.id}' : url,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final event = _event;
    if (event == null) return const Scaffold(body: Center(child: Text('Not found')));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.7),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 20.r),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: event.coverImageUrl != null && event.coverImageUrl!.isNotEmpty
                        ? () => _openFullImage(event.coverImageUrl!)
                        : null,
                    child: Hero(
                      tag: 'event_cover_${event.id}',
                      child: CachedNetworkImage(
                        imageUrl: event.coverImageUrl ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.ideaPurpleLight,
                          child: Center(
                            child: Icon(
                              Icons.event_rounded,
                              size: 64.r,
                              color: UpdateCategory.events.color.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const IgnorePointer(
                    child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x66000000), Color(0x00000000)],
                        stops: [0.0, 0.45],
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
            actions: const [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(label: UpdateCategory.events.label, color: UpdateCategory.events.color),
                  SizedBox(height: 12.h),
                  Text(event.title, style: AppTextStyles.headlineMedium),
                  SizedBox(height: 8.h),
                  Text(event.timeAgo, style: AppTextStyles.caption),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16.r, color: AppColors.primary.withValues(alpha: 0.8)),
                      SizedBox(width: 6.w),
                      Text(event.formattedTime, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  if (event.venue.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16.r, color: AppColors.primary.withValues(alpha: 0.8)),
                        SizedBox(width: 6.w),
                        Expanded(child: Text(event.venue, style: AppTextStyles.bodyMedium)),
                      ],
                    ),
                  ],
                  if (event.description != null && event.description!.isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    LinkableText(text: event.description!, style: AppTextStyles.bodyLarge),
                  ],
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showingInterest ? null : _toggleInterest,
                      icon: Icon(_interested ? Icons.check_circle_rounded : Icons.star_border_rounded),
                      label: Text(_interested ? 'Interested' : 'Show Interest'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _interested ? AppColors.statusResolved : AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleInterest() async {
    final cid = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>().user.value?.constituencyId
        : null;
    if (cid == null) {
      Get.snackbar('Sign in required', 'Please sign in to show interest.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final event = _event;
    if (event == null) return;
    setState(() => _showingInterest = true);
    try {
      await Get.find<EventsApi>().showInterest(cid, event.id);
      setState(() => _interested = true);
    } catch (_) {
      Get.snackbar('Error', 'Could not register interest. Try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _showingInterest = false);
    }
  }
}

class _FullImageView extends StatelessWidget {
  const _FullImageView({required this.url, required this.heroTag});

  final String url;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: heroTag,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  width: 40.r,
                  height: 40.r,
                  child: Icon(Icons.close_rounded, color: Colors.white, size: 22.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
