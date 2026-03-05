import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/common/widget/background_app.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/di/service_locator.dart';
import 'package:fitness_app/feature/auth/presentation/widgets/pop_widget.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view/components/previous_conversation_menu.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/constants/app_assets.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view_model/smart_coach_cubit.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/feature/chat_ai/domain/entity/smart_coach/message_entity.dart';

class SmartCoachScreen extends StatefulWidget {
  const SmartCoachScreen({super.key});

  @override
  State<SmartCoachScreen> createState() => _SmartCoachScreenState();
}

late SmartCoachCubit cubit;

class _SmartCoachScreenState extends State<SmartCoachScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showSidebar = false;
  double _menuOffset = 0.0;
  late double _menuWidth;

  @override
  void initState() {
    super.initState();
    cubit = serviceLocator.get<SmartCoachCubit>();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await cubit.loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext ctx) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final SmartCoachCubit cubit = ctx.read<SmartCoachCubit>();
    if (!cubit.state.isLoading) {
      cubit.sendMessage(text);
      _controller.clear();
    }
  }

  // السحب لليمين لإغلاق فقط
  void _onMenuDragUpdate(double delta) {
    if (delta > 0) {
      setState(() {
        _menuOffset += delta;
        _menuOffset = _menuOffset.clamp(-_menuWidth, 0.0);
      });
    }
  }

  void _onMenuDragEnd() {
    if (_menuOffset > -_menuWidth / 2) {
      // أغلق القائمة
      setState(() {
        _menuOffset = -_menuWidth;
        _showSidebar = false;
      });
    } else {
      // خليها مفتوحة
      setState(() {
        _menuOffset = 0;
        _showSidebar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _menuWidth = MediaQuery.of(context).size.width * 0.8;

    // اجعل القائمة مغلقة عند البداية
    if (!_showSidebar && _menuOffset == 0.0) {
      _menuOffset = -_menuWidth;
    }

    return BlocProvider(
      create: (_) => serviceLocator<SmartCoachCubit>(),
      child: Builder(
        builder: (ctx) => Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: BackgroundApp(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            popWidget(context, () {
                              Navigator.of(context).pop();
                            }),
                            Text(
                              LocaleKeys.smart_coach_title.tr(),
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                // افتح القائمة فقط عند الضغط على الزرار
                                setState(() {
                                  _showSidebar = true;
                                  _menuOffset = 0.0;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocConsumer<SmartCoachCubit, SmartCoachChatState>(
                          listener: (context, state) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent + 100,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          },
                          builder: (context, state) {
                            final messages = state.messages ?? [];

                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isBot = message.sender == Sender.model;
                                final text = message.text;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: isBot
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (isBot)
                                        const CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(ImageAsset.ellipse),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      if (!isBot) const SizedBox(width: 40),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          margin:
                                          const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: isBot
                                                ? AppColors.gray
                                                .withAlpha((0.07 * 255).toInt())
                                                : AppColors.orange
                                                .withAlpha((0.6 * 255).toInt()),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: const Radius.circular(20),
                                              bottomRight: const Radius.circular(20),
                                              topLeft: Radius.circular(isBot ? 0 : 20),
                                              topRight: Radius.circular(isBot ? 20 : 0),
                                            ),
                                          ),
                                          child: Text(
                                            text,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      if (!isBot)
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                          NetworkImage(cubit.state.photo.toString()),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      if (isBot) const SizedBox(width: 40),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      BlocBuilder<SmartCoachCubit, SmartCoachChatState>(
                        builder: (context, state) {
                          final bool isLoading = state.isLoading;

                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha((0.4 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: isLoading
                                            ? LocaleKeys.smart_coach_ai_typing.tr()
                                            : LocaleKeys.smart_coach_type_message.tr(),
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                      ),
                                      enabled: !isLoading,
                                      onSubmitted: (_) => _sendMessage(ctx),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: isLoading
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                      : const Icon(Icons.send, color: Colors.white),
                                  onPressed: isLoading ? null : () => _sendMessage(ctx),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Sidebar draggable
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              top: 0,
              bottom: 0,
              right: _menuOffset,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    _onMenuDragUpdate(details.delta.dx);
                  }
                },
                onHorizontalDragEnd: (_) {
                  _onMenuDragEnd();
                },
                child: SizedBox(
                  width: _menuWidth,
                  child: PreviousConversationsMenu(
                    onConversationSelected: () {
                      setState(() {
                        _showSidebar = false;
                        _menuOffset = -_menuWidth;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}