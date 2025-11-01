class ApiEndpoints {
  static const String rickAndMortyBase = 'https://rickandmortyapi.com/api';
  static const String rickAndMortyCharacters = '$rickAndMortyBase/character';
  
  static const String dogApiBase = 'https://dog.ceo/api';
  static const String dogApiBreeds = '$dogApiBase/breeds/list/all';
  static const String dogApiRandomImages = '$dogApiBase/breeds/image/random';
  
  static const String catApiBase = 'https://api.thecatapi.com/v1';
  static const String catApiBreeds = '$catApiBase/breeds';
  static const String catApiImages = '$catApiBase/images/search';

  static String rickAndMortyCharacterById(int id) => '$rickAndMortyCharacters/$id';
  static String dogImagesByBreed(String breed, int count) => '$dogApiBase/breed/$breed/images/random/$count';
}

