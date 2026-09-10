import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/image_upload_field.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/banner_form_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/banner_form_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';

class BannerEditorDialog extends StatelessWidget {
  const BannerEditorDialog({super.key});

  static Future<void> open(BuildContext context, {BannerSlide? banner}) {
    final cubit = context.read<WebsiteCubit>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => BannerFormCubit(banner: banner)),
          ],
          child: const BannerEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<BannerFormCubit>();

    return Dialog(
      child: BlocListener<BannerFormCubit, BannerFormState>(
        listenWhen: (previous, current) =>
            current.status == BannerFormStatus.success,
        listener: (context, state) {
          context.read<WebsiteCubit>().saveBanner(state.toBanner());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 560,
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formCubit.state.isEditing ? 'Edit banner' : 'Add banner',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: formCubit.state.title,
                          onChanged: formCubit.titleChanged,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: formCubit.state.subtitle,
                          minLines: 2,
                          maxLines: 3,
                          onChanged: formCubit.subtitleChanged,
                          decoration: const InputDecoration(
                            labelText: 'Subtitle',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: formCubit.state.ctaLabel,
                          onChanged: formCubit.ctaLabelChanged,
                          decoration: const InputDecoration(
                            labelText: 'Button label',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: formCubit.state.ctaLink,
                          onChanged: formCubit.ctaLinkChanged,
                          decoration: const InputDecoration(
                            labelText: 'Button link',
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<BannerFormCubit, BannerFormState>(
                          buildWhen: (previous, current) =>
                              previous.imageBytes != current.imageBytes ||
                              previous.imageUrl != current.imageUrl,
                          builder: (context, state) {
                            return ImageUploadField(
                              label: 'Banner image',
                              url: state.imageUrl,
                              bytes: state.imageBytes,
                              onPicked: formCubit.imageChanged,
                              onCleared: formCubit.imageCleared,
                            );
                          },
                        ),
                        BlocBuilder<BannerFormCubit, BannerFormState>(
                          buildWhen: (previous, current) =>
                              previous.isVisible != current.isVisible,
                          builder: (context, state) {
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Visible on website'),
                              value: state.isVisible,
                              onChanged: formCubit.visibilityChanged,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<BannerFormCubit, BannerFormState>(
                  buildWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
                    if (state.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: formCubit.submit,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
