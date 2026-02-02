import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

// --- EVENTS ---
abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class GetUserProfile extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final UserEntity user;
  const UpdateUserProfile(this.user);

  @override
  List<Object> get props => [user];
}

// --- STATES ---
abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  const UserLoaded(this.user);
  @override
  List<Object> get props => [user];
}

// [NOVO] Estado específico para quando o update finaliza com sucesso
// Ele estende UserLoaded para que a UI de perfil continue mostrando os dados
class UserUpdated extends UserLoaded {
  const UserUpdated(super.user);
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLOC ---
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UserBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(UserInitial()) {
    on<GetUserProfile>(_onGetUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUserProfileUseCase();

    result.fold(
      (failure) => emit(const UserError("Erro ao carregar perfil")),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await updateUserProfileUseCase(event.user);

    result.fold((failure) => emit(const UserError("Erro ao atualizar perfil")), (
      _,
    ) {
      // [ALTERADO] Emitimos UserUpdated para o Listener diferenciar do carregamento inicial
      emit(UserUpdated(event.user));
    });
  }
}
