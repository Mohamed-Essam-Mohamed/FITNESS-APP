import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/dialogs/app_dialogs.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view_model/smart_coach_cubit.dart';
class PreviousConversationsMenu extends StatefulWidget {
  const PreviousConversationsMenu({
    super.key,
    required this.onConversationSelected,

  });

  final VoidCallback onConversationSelected;


  @override
  State<PreviousConversationsMenu> createState() =>
      _PreviousConversationsMenuState();
}

class _PreviousConversationsMenuState extends State<PreviousConversationsMenu> {
  @override
  void initState() {
    super.initState();
    context.read<SmartCoachCubit>().fetchConversationSummaries();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SmartCoachCubit>();
    final conversations = cubit.conversationSummaries;

    return GestureDetector(

      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xEE242424),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          widget.onConversationSelected();
                        },
                        child: Text(
                          LocaleKeys.smart_coach_previous_conversations.tr(),
                          style:
                          const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: cubit.state.baseState is BaseLoadingState
                      ? const Center(
                      child: CircularProgressIndicator(color: AppColors.orange))
                      : ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final convo = conversations[index];
                      return InkWell(
                        onTap: () async {
                          cubit.fetchMessagesByConversationId(convo['id']);
                          widget.onConversationSelected();
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AppCustomDialog(
                                        title: LocaleKeys
                                            .smart_coach_delete_chat_title
                                            .tr(),
                                        message: LocaleKeys
                                            .smart_coach_delete_chat_message
                                            .tr(),
                                        onConfirm: () =>
                                            Navigator.of(context).pop(true),
                                        onCancel: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await cubit.deleteConversationById(
                                          convo['id']);
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      convo['text'] ??
                                          '${LocaleKeys.smart_coach_conversation.tr()} ${index + 1}',
                                      style: const TextStyle(
                                          color: AppColors.white),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Color(0xFF2D2D2D)),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}