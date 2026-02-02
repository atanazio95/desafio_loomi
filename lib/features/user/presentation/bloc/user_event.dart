import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';

class UpdateUserProfile extends UserEvent {
  final UserEntity user;
  const UpdateUserProfile(this.user);
}
