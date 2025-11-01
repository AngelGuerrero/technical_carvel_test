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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          if (item.description != null) ...[
            Text(
              item.description!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],
          if (item.extraData != null) ..._buildExtraData(context),
        ],
      ),
    );
  }

  List<Widget> _buildExtraData(BuildContext context) {
    final extraData = item.extraData!;
    final widgets = <Widget>[];

    widgets.add(
      Text(
        'Additional Information',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    widgets.add(const SizedBox(height: AppConstants.defaultPadding));

    extraData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        widgets.add(_buildInfoRow(context, key, value));
        widgets.add(const SizedBox(height: AppConstants.smallPadding));
      }
    });

    return widgets;
  }

  Widget _buildInfoRow(BuildContext context, String key, dynamic value) {
    final formattedKey = key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                formattedKey,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

