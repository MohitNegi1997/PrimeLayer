import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/core/widgets/media_thumb.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/banner_carousel_preview.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/banner_editor_dialog.dart';

class BannersPanel extends StatelessWidget {
  const BannersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebsiteCubit, WebsiteState>(
      builder: (context, state) {
        return AdminListScaffold(
          embedded: true,
          title: '',
          subtitle: '',
          actions: [
            ElevatedButton.icon(
              onPressed: () => BannerEditorDialog.open(context),
              icon: const Icon(Icons.add),
              label: const Text('Add banner'),
            ),
          ],
          stats: [
            AdminStatMetric(
              label: 'Total banners',
              value: '${state.banners.length}',
              caption: 'Created',
              icon: Icons.view_carousel_outlined,
            ),
            AdminStatMetric(
              label: 'Live',
              value: '${state.visibleBanners.length}',
              caption: 'On website',
              icon: Icons.visibility_outlined,
              tone: AdminChipTone.success,
            ),
            AdminStatMetric(
              label: 'Hidden',
              value: '${state.banners.length - state.visibleBanners.length}',
              caption: 'Off website',
              icon: Icons.visibility_off_outlined,
              tone: AdminChipTone.muted,
            ),
            AdminStatMetric(
              label: 'Preview',
              value: state.previewBanner == null ? '0' : '1',
              caption: 'Current slide',
              icon: Icons.slideshow_outlined,
              tone: AdminChipTone.info,
            ),
          ],
          leading: const BannerCarouselPreview(),
          columns: const [
            AdminTableColumn(label: 'Banner', flex: 3),
            AdminTableColumn(label: 'Button'),
            AdminTableColumn(label: 'Link', flex: 2),
            AdminTableColumn(label: 'Status'),
            AdminTableColumn(label: 'Actions', flex: 1),
          ],
          rowCount: state.banners.length,
          cells: (index) => _cells(context, state.banners[index]),
          onRowTap: (index) => BannerEditorDialog.open(
            context,
            banner: state.banners[index],
          ),
          emptyLabel: 'No banners yet',
          page: 0,
          total: state.banners.length,
          onPageChanged: (_) {},
        );
      },
    );
  }

  List<Widget> _cells(BuildContext context, BannerSlide banner) {
    return [
      Row(
        children: [
          MediaThumb(
            url: banner.imageUrl,
            bytes: banner.imageBytes,
            icon: Icons.view_carousel_outlined,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminTextCell(banner.title, emphasis: true),
                AdminTextCell(banner.subtitle),
              ],
            ),
          ),
        ],
      ),
      AdminTextCell(banner.ctaLabel.isEmpty ? '—' : banner.ctaLabel),
      AdminTextCell(banner.ctaLink.isEmpty ? '—' : banner.ctaLink),
      StatusChip(
        label: banner.isVisible ? 'Visible' : 'Hidden',
        tone: banner.isVisible ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              BannerEditorDialog.open(context, banner: banner);
            case 'visibility':
              context.read<WebsiteCubit>().toggleBannerVisibility(banner.id);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete ${banner.title}?',
                message: 'This banner will leave the website carousel.',
                onConfirm: () =>
                    context.read<WebsiteCubit>().deleteBanner(banner.id),
              );
          }
        },
        items: [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(
            value: 'visibility',
            child: Text(banner.isVisible ? 'Hide' : 'Show'),
          ),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }
}
