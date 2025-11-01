class ItemModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final Map<String, dynamic>? extraData;

  ItemModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.extraData,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'],
      description: json['description'],
      extraData: json['extraData'],
    );
  }

  factory ItemModel.fromRickAndMorty(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'],
      description: 'Status: ${json['status']} - Species: ${json['species']}',
      extraData: {
        'status': json['status'],
        'species': json['species'],
        'gender': json['gender'],
        'origin': json['origin']?['name'],
        'location': json['location']?['name'],
        'episode_count': (json['episode'] as List?)?.length ?? 0,
        'created': json['created'],
      },
    );
  }

  factory ItemModel.fromDogApi(String breed, String imageUrl, int index) {
    return ItemModel(
      id: '$breed-$index',
      name: breed.split('/').map((word) => 
        word[0].toUpperCase() + word.substring(1)
      ).join(' '),
      imageUrl: imageUrl,
      description: 'Dog breed: $breed',
      extraData: {
        'breed': breed,
        'type': 'dog',
      },
    );
  }

  factory ItemModel.fromCatApi(Map<String, dynamic> json) {
    final breed = json['breeds'] != null && (json['breeds'] as List).isNotEmpty
        ? json['breeds'][0]
        : null;
    
    return ItemModel(
      id: json['id']?.toString() ?? '',
      name: breed?['name'] ?? 'Cat ${json['id']}',
      imageUrl: json['url'],
      description: breed?['description'] ?? 'A beautiful cat',
      extraData: {
        'breed': breed?['name'],
        'temperament': breed?['temperament'],
        'origin': breed?['origin'],
        'life_span': breed?['life_span'],
        'type': 'cat',
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'extraData': extraData,
    };
  }

  ItemModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    Map<String, dynamic>? extraData,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      extraData: extraData ?? this.extraData,
    );
  }
}

