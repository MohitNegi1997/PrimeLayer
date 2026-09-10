import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_header.dart';
import 'package:primelayer_admin_panel/features/website/domain/website_section.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/banners_panel.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/faqs_panel.dart';
import 'package:primelayer_admin_panel/features/website/presentation/widgets/site_content_panel.dart';

class WebsiteView extends StatelessWidget {
  const WebsiteView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return BlocListener<WebsiteCubit, WebsiteState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<WebsiteCubit>().clearNotice();
      },
      child: BlocBuilder<WebsiteCubit, WebsiteState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AdminPageHeader(
                  title: 'Website',
                  subtitle:
                      'Manage banners, FAQs, and storefront copy shown to customers.',
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SegmentedButton<WebsiteSection>(
                      segments: [
                        for (final value in WebsiteSection.values)
                          ButtonSegment<WebsiteSection>(
                            value: value,
                            label: Text(value.label),
                          ),
                      ],
                      selected: {state.section},
                      showSelectedIcon: !isMobile,
                      onSelectionChanged: (selection) {
                        context.read<WebsiteCubit>().sectionChanged(
                          selection.first,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _section(state.section)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _section(WebsiteSection section) {
    return switch (section) {
      WebsiteSection.banners => const BannersPanel(),
      WebsiteSection.faqs => const FaqsPanel(),
      WebsiteSection.content => const SiteContentPanel(),
    };
  }
}
