import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import 'items_provider.dart';

class SearchState {
  final String query;
  final List<ItemModel> results;
  final bool isSearching;
  final String? error;

  SearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<ItemModel>? results,
    bool? isSearching,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final ItemRepository _repository;
  Timer? _debounceTimer;

  SearchNotifier(this._repository) : super(SearchState());

  void updateQuery(String query) {
    state = state.copyWith(query: query);

    _debounceTimer?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    _debounceTimer = Timer(AppConstants.searchDebounce, () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    state = state.copyWith(isSearching: true, error: null);

    try {
      final results = await _repository.searchItems(query);
      
      if (state.query == query) {
        state = state.copyWith(
          results: results,
          isSearching: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e is ApiException ? e.message : e.toString(),
      );
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    state = SearchState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return SearchNotifier(repository);
});

