import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/recent_alert_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when entering the page,
    // after the initial frame to avoid synchronous rebuilds during navigation animation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AlertCubit>().markAllRead();
      }
    });

    _scrollController.addListener(_onScroll);
    _loadInitialPage();
  }

  void _loadInitialPage() {
    final cubit = context.read<AlertCubit>();
    _hasMore = cubit.hasMorePages(0);
  }

  void _onScroll() {
    if (!_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    final cubit = context.read<AlertCubit>();
    final nextPage = _currentPage + 1;
    final nextItems = cubit.getPage(nextPage);

    if (nextItems.isNotEmpty) {
      setState(() {
        _currentPage = nextPage;
        _hasMore = cubit.hasMorePages(nextPage);
      });
    } else {
      setState(() => _hasMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notificationsTitle)),
      body: BlocBuilder<AlertCubit, AlertState>(
        builder: (context, _) {
          final cubit = context.read<AlertCubit>();
          // Collect all items up to and including the current page.
          final pageSize = 10;
          final totalItems = (_currentPage + 1) * pageSize;
          final alerts = cubit.alertHistory.take(totalItems).toList();

          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64.responsive(context),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 16.responsive(context)),
                  Text(
                    AppStrings.noNotifications,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: 16.responsive(context),
              vertical: 12.responsive(context),
            ),
            itemCount: alerts.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= alerts.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.responsive(context),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24.responsive(context),
                      height: 24.responsive(context),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final alert = alerts[index];
              return RecentAlertTile(
                key: ValueKey(
                  '${alert.deviceId}_${alert.timestamp.millisecondsSinceEpoch}',
                ),
                alert: alert,
              );
            },
          );
        },
      ),
    );
  }
}
