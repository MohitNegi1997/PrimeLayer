import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/media_thumb.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_state.dart';

class BannerCarouselPreview extends StatelessWidget {
  const BannerCarouselPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<WebsiteCubit, WebsiteState>(
      builder: (context, state) {
        final banner = state.previewBanner;
        if (banner == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No visible banners. Hidden banners stay off the website carousel.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Previous',
                  onPressed: state.visibleBanners.length < 2
                      ? null
                      : () {
                          final next = state.previewIndex == 0
                              ? state.visibleBanners.length - 1
                              : state.previewIndex - 1;
                          context.read<WebsiteCubit>().previewChanged(next);
                        },
                  icon: const Icon(Icons.chevron_left),
                ),
                MediaThumb(
                  url: banner.imageUrl,
                  bytes: banner.imageBytes,
                  icon: Icons.view_carousel_outlined,
                ),
                const SizedBox(width: 12),
                Expanded(child: _copy(theme, banner, state)),
                IconButton(
                  tooltip: 'Next',
                  onPressed: state.visibleBanners.length < 2
                      ? null
                      : () {
                          final next =
                              (state.previewIndex + 1) %
                              state.visibleBanners.length;
                          context.read<WebsiteCubit>().previewChanged(next);
                        },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _copy(ThemeData theme, BannerSlide banner, WebsiteState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Website carousel · ${state.previewIndex + 1} / ${state.visibleBanners.length}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Text(banner.title, style: theme.textTheme.titleMedium),
        Text(
          banner.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
