import 'package:flutter/material.dart';
import '../../../../data/models/item_model.dart';
import '../../../../core/constants/app_constants.dart';

class DetailContent extends StatelessWidget {
  final ItemModel item;

  const DetailContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          if (item.extraData != null) ..._buildHighlightedBadges(context),
          const SizedBox(height: AppConstants.largePadding),
          if (item.extraData != null) ..._buildExtraData(context),
        ],
      ),
    );
  }

  List<Widget> _buildHighlightedBadges(BuildContext context) {
    final extraData = item.extraData!;
    final badges = <Widget>[];

    final highlightedKeys = ['status', 'species', 'breed', 'temperament'];
    final highlightedData = extraData.entries
        .where((e) => highlightedKeys.contains(e.key.toLowerCase()) && 
                     e.value != null && 
                     e.value.toString().isNotEmpty)
        .toList();

    if (highlightedData.isEmpty) return [];

    badges.add(
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: highlightedData.map((entry) {
          final icon = _getIconForKey(entry.key);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Text(
                  entry.value.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    return badges;
  }

  List<Widget> _buildExtraData(BuildContext context) {
    final extraData = item.extraData!;
    final widgets = <Widget>[];

    final highlightedKeys = ['status', 'species', 'breed', 'temperament'];
    final excludedKeys = ['created'];
    final entries = extraData.entries
        .where((entry) =>
            !highlightedKeys.contains(entry.key.toLowerCase()) &&
            !excludedKeys.contains(entry.key.toLowerCase()) &&
            entry.value != null &&
            entry.value.toString().isNotEmpty)
        .toList();

    if (entries.isEmpty) return [];

    widgets.add(
      Text(
        'More Details',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
    widgets.add(const SizedBox(height: AppConstants.defaultPadding));

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      widgets.add(_buildInfoRow(context, entry.key, entry.value));

      if (i < entries.length - 1) {
        widgets.add(const SizedBox(height: AppConstants.defaultPadding));
      }
    }

    return widgets;
  }

  Widget _buildInfoRow(BuildContext context, String key, dynamic value) {
    final formattedKey = key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    final icon = _getIconForKey(key);

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedKey,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData? _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'status':
        return Icons.favorite;
      case 'species':
        return Icons.pets;
      case 'gender':
        return Icons.person;
      case 'origin':
        return Icons.public;
      case 'location':
        return Icons.location_on;
      case 'episode_count':
        return Icons.movie;
      case 'breed':
        return Icons.category;
      case 'temperament':
        return Icons.mood;
      case 'life_span':
        return Icons.timeline;
      case 'created':
        return Icons.calendar_today;
      default:
        return Icons.label;
    }
  }

}

