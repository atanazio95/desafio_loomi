import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit(this.getCategoriesUseCase) : super(const CategoriesState());

  Future<void> loadCategories() async {
    if (state.categories.isNotEmpty) return;
    emit(state.copyWith(isLoading: true, error: null));
    final result = await getCategoriesUseCase();
    result.fold(
      (_) => emit(state.copyWith(
        isLoading: false,
        error: 'Não foi possível carregar as categorias.',
      )),
      (categories) => emit(state.copyWith(
        categories: categories,
        isLoading: false,
        error: null,
      )),
    );
  }
}
