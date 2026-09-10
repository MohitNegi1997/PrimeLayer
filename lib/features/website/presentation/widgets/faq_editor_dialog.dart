import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/faq_form_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/faq_form_state.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';

class FaqEditorDialog extends StatelessWidget {
  const FaqEditorDialog({super.key});

  static Future<void> open(BuildContext context, {SiteFaq? faq}) {
    final cubit = context.read<WebsiteCubit>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => FaqFormCubit(faq: faq)),
          ],
          child: const FaqEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<FaqFormCubit>();

    return Dialog(
      child: BlocListener<FaqFormCubit, FaqFormState>(
        listenWhen: (previous, current) =>
            current.status == FaqFormStatus.success,
        listener: (context, state) {
          context.read<WebsiteCubit>().saveFaq(state.toFaq());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 480,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formCubit.state.id == null ? 'Add FAQ' : 'Edit FAQ',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: formCubit.state.question,
                  onChanged: formCubit.questionChanged,
                  decoration: const InputDecoration(labelText: 'Question'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.answer,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: formCubit.answerChanged,
                  decoration: const InputDecoration(labelText: 'Answer'),
                ),
                BlocBuilder<FaqFormCubit, FaqFormState>(
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
                BlocBuilder<FaqFormCubit, FaqFormState>(
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
