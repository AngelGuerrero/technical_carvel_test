import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/item_model.dart';

abstract class ApiDataSource {
  Future<List<ItemModel>> fetchItems({int page = 1, int limit = 20});
  Future<ItemModel> fetchItemById(String id);
  Future<List<ItemModel>> searchItems(String query);
}

class RickAndMortyDataSource implements ApiDataSource {
  final ApiClient _client;

  RickAndMortyDataSource(this._client);

  @override
  Future<List<ItemModel>> fetchItems({int page = 1, int limit = 20}) async {
    final response = await _client.get(
      ApiEndpoints.rickAndMortyCharacters,
      queryParams: {'page': page},
    );

    final results = response['results'] as List;
    return results.map((json) => ItemModel.fromRickAndMorty(json)).toList();
  }

  @override
  Future<ItemModel> fetchItemById(String id) async {
    final response = await _client.get(
      ApiEndpoints.rickAndMortyCharacterById(int.parse(id)),
    );

    return ItemModel.fromRickAndMorty(response);
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    final response = await _client.get(
      ApiEndpoints.rickAndMortyCharacters,
      queryParams: {'name': query},
    );

    final results = response['results'] as List;
    return results.map((json) => ItemModel.fromRickAndMorty(json)).toList();
  }
}

class DogApiDataSource implements ApiDataSource {
  final ApiClient _client;
  List<String>? _cachedBreeds;

  DogApiDataSource(this._client);

  Future<List<String>> _getBreeds() async {
    if (_cachedBreeds != null) return _cachedBreeds!;

    final response = await _client.get(ApiEndpoints.dogApiBreeds);
    final message = response['message'] as Map<String, dynamic>;
    
    _cachedBreeds = message.keys.toList();
    return _cachedBreeds!;
  }

  @override
  Future<List<ItemModel>> fetchItems({int page = 1, int limit = 20}) async {
    final breeds = await _getBreeds();
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= breeds.length) return [];
    
    final breedsSubset = breeds.sublist(
      startIndex,
      endIndex > breeds.length ? breeds.length : endIndex,
    );

    final items = <ItemModel>[];
    for (var i = 0; i < breedsSubset.length; i++) {
      final breed = breedsSubset[i];
      try {
        final response = await _client.get(
          ApiEndpoints.dogImagesByBreed(breed, 1),
        );
        final imageUrl = (response['message'] as List).first;
        items.add(ItemModel.fromDogApi(breed, imageUrl, startIndex + i));
      } catch (e) {
        continue;
      }
    }

    return items;
  }

  @override
  Future<ItemModel> fetchItemById(String id) async {
    final parts = id.split('-');
    final breed = parts[0];
    
    final response = await _client.get(
      ApiEndpoints.dogImagesByBreed(breed, 1),
    );
    final imageUrl = (response['message'] as List).first;
    
    return ItemModel.fromDogApi(breed, imageUrl, int.parse(parts[1]));
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    final breeds = await _getBreeds();
    final filteredBreeds = breeds
        .where((breed) => breed.toLowerCase().contains(query.toLowerCase()))
        .take(20)
        .toList();

    final items = <ItemModel>[];
    for (var i = 0; i < filteredBreeds.length; i++) {
      final breed = filteredBreeds[i];
      try {
        final response = await _client.get(
          ApiEndpoints.dogImagesByBreed(breed, 1),
        );
        final imageUrl = (response['message'] as List).first;
        items.add(ItemModel.fromDogApi(breed, imageUrl, i));
      } catch (e) {
        continue;
      }
    }

    return items;
  }
}

class CatApiDataSource implements ApiDataSource {
  final ApiClient _client;

  CatApiDataSource(this._client);

  @override
  Future<List<ItemModel>> fetchItems({int page = 1, int limit = 20}) async {
    final response = await _client.get(
      ApiEndpoints.catApiImages,
      queryParams: {
        'limit': limit,
        'page': page - 1,
        'has_breeds': 1,
      },
    );

    final results = response as List;
    return results.map((json) => ItemModel.fromCatApi(json)).toList();
  }

  @override
  Future<ItemModel> fetchItemById(String id) async {
    final response = await _client.get('${ApiEndpoints.catApiImages}/$id');
    return ItemModel.fromCatApi(response);
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    final response = await _client.get(
      ApiEndpoints.catApiBreeds,
      queryParams: {'q': query},
    );

    final results = response as List;
    if (results.isEmpty) return [];

    final breedId = results.first['id'];
    final imagesResponse = await _client.get(
      ApiEndpoints.catApiImages,
      queryParams: {
        'breed_ids': breedId,
        'limit': 20,
      },
    );

    final images = imagesResponse as List;
    return images.map((json) => ItemModel.fromCatApi(json)).toList();
  }
}

