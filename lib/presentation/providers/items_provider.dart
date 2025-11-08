import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/api_datasource.dart';
import '../../data/repositories/item_repository.dart';
import '../../data/models/item_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final apiDataSourceProvider = Provider<ApiDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return RickAndMortyDataSource(client);
});

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final dataSource = ref.watch(apiDataSourceProvider);
  return ItemRepository(dataSource);
});

class ItemsState {
  final List<ItemModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int currentPage;

  ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ItemsState copyWith({
    List<ItemModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ItemsNotifier extends StateNotifier<ItemsState> {
  final ItemRepository _repository;

  ItemsNotifier(this._repository) : super(ItemsState());

  Future<void> loadItems() async {
    if (state.isLoading || state.isLoadingMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _repository.getItems(
        page: 1,
        limit: AppConstants.itemsPerPage,
      );

      state = state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length >= AppConstants.itemsPerPage,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is ApiException ? e.message : e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.currentPage + 1;
      final newItems = await _repository.getItems(
        page: nextPage,
        limit: AppConstants.itemsPerPage,
      );

      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoadingMore: false,
        hasMore: newItems.length >= AppConstants.itemsPerPage,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e is ApiException ? e.message : e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = ItemsState();
    await loadItems();
  }
}

final itemsProvider = StateNotifierProvider<ItemsNotifier, ItemsState>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return ItemsNotifier(repository);
});

final itemDetailProvider = FutureProvider.family<ItemModel, String>((ref, id) async {
  final repository = ref.watch(itemRepositoryProvider);
  return repository.getItemById(id);
});

