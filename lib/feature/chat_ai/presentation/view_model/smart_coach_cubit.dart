import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/dummy/dummy_constant.dart';
import 'package:fitness_app/core/storage_helper/app_shared_preference_helper.dart';
import 'package:fitness_app/feature/chat_ai/data/api/gemini_custom_exception.dart';
import 'package:fitness_app/feature/chat_ai/domain/entity/smart_coach/message_entity.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/delete_conversation_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/fetch_conversation_summaries_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/fetch_messages_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/get_smart_coach_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/save_messages_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/set_conversation_title_usecase.dart';
import 'package:fitness_app/feature/chat_ai/domain/use_case/start_new_conversation_usecase.dart';
import 'package:fitness_app/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/feature/chat_ai/presentation/view_model/smart_coach_state.dart';
import 'package:injectable/injectable.dart';
@injectable
class SmartCoachCubit extends Cubit<SmartCoachChatState> {
  SmartCoachCubit(
      this.getSmartCoachResponseUseCase,
      this._setConversationTitleUseCase,
      this._startNewConversationUseCase,
      this._saveMessagesUseCase,
      this._fetchMessagesUseCase,
      this._fetchConversationSummariesUseCase,
      this._deleteConversationUseCase)
      : super(SmartCoachChatState(baseState: BaseInitialState())) {
    // ✅ أزل _startNewConversation() من هنا
  }

  final DeleteConversationUseCase _deleteConversationUseCase;
  final FetchConversationSummariesUseCase _fetchConversationSummariesUseCase;
  final FetchMessagesUseCase _fetchMessagesUseCase;
  final SaveMessagesUseCase _saveMessagesUseCase;
  final SetConversationTitleUseCase _setConversationTitleUseCase;
  final StartNewConversationUseCase _startNewConversationUseCase;
  final GetSmartCoachResponseUseCase getSmartCoachResponseUseCase;

  String? _currentConversationId;
  StreamSubscription<String>? _chatStreamSubscription;

  @override
  Future<void> close() {
    _chatStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> loadUserData() async {
    final user = await SharedPreferencesHelper.getDataUserPref();
    emit(state.copyWith(
      firstName: user?.firstName ?? 'Mohamed Ali',
      photo: user?.firstName ?? dummyImageProfileUrl,
    ));
  }

  // ❌ أزل _startNewConversation هنا

  void loadConversation(String conversationId, List<MessageEntity> messages) {
    _currentConversationId = conversationId;
    emit(state.copyWith(messages: messages));
  }

  List<Map<String, dynamic>> _conversationSummaries = [];
  List<Map<String, dynamic>> get conversationSummaries => _conversationSummaries;

  Future<void> fetchConversationSummaries() async {
    emit(state.copyWith(baseState: BaseLoadingState()));
    try {
      _conversationSummaries = await _fetchConversationSummariesUseCase.call();
      emit(state.copyWith(baseState: BaseSuccessState()));
    } catch (e) {
      emit(state.copyWith(baseState: BaseErrorState(errorMessage: e.toString())));
    }
  }

  Future<void> fetchMessagesByConversationId(String conversationId) async {
    emit(state.copyWith(baseState: BaseLoadingState()));
    try {
      final messages = await _fetchMessagesUseCase.call(conversationId);
      _currentConversationId = conversationId;
      emit(state.copyWith(
        messages: messages,
        baseState: BaseSuccessState(),
      ));
    } catch (e) {
      emit(state.copyWith(
        baseState: BaseErrorState(errorMessage: e.toString()),
      ));
    }
  }

  Future<void> deleteConversationById(String id) async {
    try {
      await _deleteConversationUseCase.call(id);
      await fetchConversationSummaries();
    } catch (e) {
      emit(state.copyWith(baseState: BaseErrorState(errorMessage: e.toString())));
    }
  }

  void sendMessage(String prompt) async {
    // لو الرسالة فارغة، لا تفعل شيء
    if (prompt.trim().isEmpty) return;

    emit(state.copyWith(
      baseState: BaseLoadingState(),
      isLoading: true,
      errorMessage: null,
    ));

    final userMessage = MessageEntity(text: prompt, sender: Sender.user);

    // ✅ أنشئ المحادثة فقط إذا لم تكن موجودة مسبقًا
    if (_currentConversationId == null) {
      _currentConversationId = await _startNewConversationUseCase.call();
      await _setConversationTitleUseCase.call(_currentConversationId!, prompt);
    }

    await _saveMessagesUseCase.call(_currentConversationId!, userMessage);

    final messagesWithNewUser = [...?state.messages, userMessage];
    emit(state.copyWith(messages: messagesWithNewUser));

    final aiMessagePlaceholder = MessageEntity(text: '', sender: Sender.model);
    final messagesWithPlaceholder = [...messagesWithNewUser, aiMessagePlaceholder];
    emit(state.copyWith(messages: messagesWithPlaceholder));

    final StringBuffer buffer = StringBuffer();
    final List<MessageEntity> updatedList = List.from(messagesWithPlaceholder);

    await _chatStreamSubscription?.cancel();

    _chatStreamSubscription =
        getSmartCoachResponseUseCase.call(messagesWithNewUser).listen(
              (chunk) {
            buffer.write(chunk);

            if (updatedList.isNotEmpty && updatedList.last.sender == Sender.user) {
              updatedList.add(aiMessagePlaceholder.copyWith(text: buffer.toString()));
            } else if (updatedList.isNotEmpty) {
              updatedList[updatedList.length - 1] =
                  aiMessagePlaceholder.copyWith(text: buffer.toString());
            }

            emit(state.copyWith(messages: updatedList));
          },
          onError: (error) {
            String displayErrorMessage = 'An unknown error occurred. Please try again.';
            Exception? exceptionToReport;

            if (error is ServerException) {
              exceptionToReport = error;
              if (error.statusCode == 429) {
                displayErrorMessage = LocaleKeys.smart_coach_too_many_requests.tr();
              } else {
                displayErrorMessage =
                ' ${LocaleKeys.smart_coach_too_many_requests.tr()} ${error.message}';
              }
            }

            final errorMessagesList = List<MessageEntity>.from(state.messages ?? []);
            _updateLastMessageWithError(displayErrorMessage, errorMessagesList);

            emit(state.copyWith(
              baseState: BaseErrorState(
                errorMessage: displayErrorMessage,
                exception: exceptionToReport,
              ),
              isLoading: false,
              errorMessage: displayErrorMessage,
            ));
          },
          onDone: () async {
            emit(state.copyWith(
              baseState: BaseSuccessState(),
              isLoading: false,
              errorMessage: null,
            ));

            if (updatedList.isNotEmpty &&
                updatedList.last.sender == Sender.model &&
                updatedList.last.text.isNotEmpty) {
              await _saveMessagesUseCase.call(
                _currentConversationId!,
                updatedList.last,
              );
            }
          },
        );
  }

  void _updateLastMessageWithError(
      String errorMessage, List<MessageEntity>? currentMessages) {
    final updatedMessageList = List<MessageEntity>.from(currentMessages!);
    if (updatedMessageList.isNotEmpty &&
        updatedMessageList.last.sender == Sender.model &&
        updatedMessageList.last.text.isEmpty) {
      updatedMessageList[updatedMessageList.length - 1] =
          updatedMessageList.last.copyWith(text: errorMessage);
    } else {
      updatedMessageList.add(MessageEntity(text: errorMessage, sender: Sender.model));
    }
    emit(state.copyWith(messages: updatedMessageList));
  }
}