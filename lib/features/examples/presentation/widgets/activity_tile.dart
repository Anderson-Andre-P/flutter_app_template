import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../domain/entities/activity.dart';

/// One statement row: icon, title + method, signed amount.
class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.activity, this.onTap});

  final Activity activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final income = activity.isIncome;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: AppListTile(
        title: activity.title,
        subtitle: activity.method,
        leading: AppIconBox(
          icon: income ? Icons.south_west : Icons.north_east,
          tone: income ? AppTone.success : AppTone.primary,
        ),
        trailing: Text(
          formatCents(activity.amountCents, signed: true),
          style: AppTypography.label.copyWith(
            color: income ? c.success : c.textPrimary,
          ),
        ),
      ),
    );
  }
}
