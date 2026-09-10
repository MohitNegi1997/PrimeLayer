import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_scaffold.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/site_content_form_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/site_content_form_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';

class SiteContentPanel extends StatelessWidget {
  const SiteContentPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SiteContentFormCubit(
        context.read<WebsiteCubit>().state.content,
      ),
      child: const _SiteContentForm(),
    );
  }
}

class _SiteContentForm extends StatelessWidget {
  const _SiteContentForm();

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<SiteContentFormCubit>();
    final theme = Theme.of(context);

    return BlocListener<SiteContentFormCubit, SiteContentFormState>(
      listenWhen: (previous, current) =>
          current.status == SiteContentFormStatus.success,
      listener: (context, state) {
        context.read<WebsiteCubit>().saveContent(state.toContent());
      },
      child: AdminPageScaffold(
        embedded: true,
        title: '',
        subtitle: '',
        child: Card(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: formCubit.state.heroTitle,
                  onChanged: formCubit.heroTitleChanged,
                  decoration: const InputDecoration(labelText: 'Hero title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.heroSubtitle,
                  onChanged: formCubit.heroSubtitleChanged,
                  decoration: const InputDecoration(labelText: 'Hero subtitle'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.about,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: formCubit.aboutChanged,
                  decoration: const InputDecoration(labelText: 'About'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.email,
                  onChanged: formCubit.emailChanged,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.phone,
                  onChanged: formCubit.phoneChanged,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.instagram,
                  onChanged: formCubit.instagramChanged,
                  decoration: const InputDecoration(labelText: 'Instagram'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.whatsapp,
                  onChanged: formCubit.whatsappChanged,
                  decoration: const InputDecoration(labelText: 'WhatsApp'),
                ),
                BlocBuilder<SiteContentFormCubit, SiteContentFormState>(
                  builder: (context, state) {
                    if (state.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: formCubit.submit,
                    child: const Text('Save site copy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
