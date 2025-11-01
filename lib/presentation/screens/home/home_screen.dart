import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/items_provider.dart';
import '../../providers/search_provider.dart';
import 'widgets/item_card.dart';
import 'widgets/loading_skeleton.dart';
import 'widgets/search_bar.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    Future.microtask(() {
      ref.read(itemsProvider.notifier).loadItems();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    
    if (position.pixels > 500 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (position.pixels <= 500 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }

    if (position.pixels >= position.maxScrollExtent * 0.8) {
      ref.read(itemsProvider.notifier).loadMore();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _launchPortfolio() async {
    final uri = Uri.parse('https://angelguerrero.vercel.app/');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open portfolio')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const CustomSearchBar(),
              Expanded(child: _buildContent(itemsState, searchState)),
              const SizedBox(height: 48),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(context),
          ),
        ],
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: _launchPortfolio,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Creado por ',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                TextSpan(
                  text: 'Ángel Guerrero',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' ❤'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ItemsState itemsState, SearchState searchState) {
    if (searchState.query.isNotEmpty) {
      return _buildSearchResults(searchState);
    }

    if (itemsState.isLoading && itemsState.items.isEmpty) {
      return const LoadingSkeleton();
    }

    if (itemsState.error != null && itemsState.items.isEmpty) {
      return _buildError(itemsState.error!);
    }

    if (itemsState.items.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(itemsProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: itemsState.items.length + (itemsState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= itemsState.items.length) {
            return const Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
            child: ItemCard(
              item: itemsState.items[index],
              index: index,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchState searchState) {
    if (searchState.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null) {
      return _buildError(searchState.error!);
    }

    if (searchState.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: searchState.results.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
        child: ItemCard(
          item: searchState.results[index],
          index: index,
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(itemsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No items available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

