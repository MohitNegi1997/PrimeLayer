import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/faq_editor_dialog.dart';

class FaqsPanel extends StatelessWidget {
  const FaqsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebsiteCubit, WebsiteState>(
      builder: (context, state) {
        var visible = 0;
        for (final faq in state.faqs) {
          if (faq.isVisible) visible += 1;
        }
        return AdminListScaffold(
          embedded: true,
          title: '',
          subtitle: '',
          actions: [
            ElevatedButton.icon(
              onPressed: () => FaqEditorDialog.open(context),
              icon: const Icon(Icons.add),
              label: const Text('Add FAQ'),
            ),
          ],
          stats: [
            AdminStatMetric(
              label: 'Total FAQs',
              value: '${state.faqs.length}',
              caption: 'Created',
              icon: Icons.help_outline,
            ),
            AdminStatMetric(
              label: 'Visible',
              value: '$visible',
              caption: 'On website',
              icon: Icons.visibility_outlined,
              tone: AdminChipTone.success,
            ),
            AdminStatMetric(
              label: 'Hidden',
              value: '${state.faqs.length - visible}',
              caption: 'Off website',
              icon: Icons.visibility_off_outlined,
              tone: AdminChipTone.muted,
            ),
            AdminStatMetric(
              label: 'Answered',
              value: '${[
                for (final faq in state.faqs)
                  if (faq.answer.trim().isNotEmpty) faq,
              ].length}',
              caption: 'With copy',
              icon: Icons.notes_outlined,
              tone: AdminChipTone.info,
            ),
          ],
          columns: const [
            AdminTableColumn(label: 'Question', flex: 3),
            AdminTableColumn(label: 'Answer', flex: 4),
            AdminTableColumn(label: 'Status'),
            AdminTableColumn(label: 'Actions', flex: 1),
          ],
          rowCount: state.faqs.length,
          cells: (index) => _cells(context, state.faqs[index]),
          onRowTap: (index) => FaqEditorDialog.open(
            context,
            faq: state.faqs[index],
          ),
          emptyLabel: 'No FAQs yet',
          page: 0,
          total: state.faqs.length,
          onPageChanged: (_) {},
        );
      },
    );
  }

  List<Widget> _cells(BuildContext context, SiteFaq faq) {
    return [
      AdminTextCell(faq.question, emphasis: true),
      AdminTextCell(faq.answer),
      StatusChip(
        label: faq.isVisible ? 'Visible' : 'Hidden',
        tone: faq.isVisible ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              FaqEditorDialog.open(context, faq: faq);
            case 'visibility':
              context.read<WebsiteCubit>().toggleFaqVisibility(faq.id);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete this FAQ?',
                message: 'This cannot be undone.',
                onConfirm: () =>
                    context.read<WebsiteCubit>().deleteFaq(faq.id),
              );
          }
        },
        items: [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(
            value: 'visibility',
            child: Text(faq.isVisible ? 'Hide' : 'Show'),
          ),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }
}
