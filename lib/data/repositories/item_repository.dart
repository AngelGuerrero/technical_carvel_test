import '../../core/network/api_exception.dart';
import '../datasources/api_datasource.dart';
import '../models/item_model.dart';

class ItemRepository {
  final ApiDataSource _dataSource;

  ItemRepository(this._dataSource);

  Future<List<ItemModel>> getItems({int page = 1, int limit = 20}) async {
    try {
      return await _dataSource.fetchItems(page: page, limit: limit);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch items: $e');
    }
  }

  Future<ItemModel> getItemById(String id) async {
    try {
      return await _dataSource.fetchItemById(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch item details: $e');
    }
  }

  Future<List<ItemModel>> searchItems(String query) async {
    if (query.isEmpty) return [];
    
    try {
      return await _dataSource.searchItems(query);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to search items: $e');
    }
  }
}

