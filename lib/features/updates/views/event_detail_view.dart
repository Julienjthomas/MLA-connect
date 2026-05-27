import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/linkable_text.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/event_service.dart';
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
              padding: const EdgeInsets.all(8),
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.7),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Get.back(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.coverImageUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.ideaPurpleLight,
                      child: Center(
                        child: Icon(
                          Icons.event_rounded,
                          size: 64,
                          color: UpdateCategory.events.color.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x66000000), Color(0x00000000)],
                        stops: [0.0, 0.45],
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(label: UpdateCategory.events.label, color: UpdateCategory.events.color),
                  const SizedBox(height: 12),
                  Text(event.title, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(event.timeAgo, style: AppTextStyles.caption),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary.withValues(alpha: 0.8)),
                      const SizedBox(width: 6),
                      Text(event.formattedTime, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  if (event.venue.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Expanded(child: Text(event.venue, style: AppTextStyles.bodyMedium)),
                      ],
                    ),
                  ],
                  if (event.description != null && event.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    LinkableText(text: event.description!, style: AppTextStyles.bodyLarge),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
