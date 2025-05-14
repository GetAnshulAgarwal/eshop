import '../model/offer.dart';

// Mock data for UI testing
class MockData {
  static List<Map<String, dynamic>> getMockBakedProducts() {
    return [
      {
        'title': 'Golden Mango Twist',
        'flavour': 'Mango',
        'rating': 4.8,
        'image': 'https://picsum.photos/200?random=10',
      },
      {
        'title': 'Fruit Magic Tart',
        'flavour': 'Pineapple, Strawberry',
        'rating': 4.9,
        'image': 'https://picsum.photos/200?random=11',
      },
      {
        'title': 'Lemon Sponge Cake',
        'flavour': 'Lemon',
        'rating': 4.7,
        'image': 'https://picsum.photos/200?random=12',
      },
      {
        'title': 'Mini Cake with Fruits',
        'flavour': 'Mango, Strawberry, Chocolate, Berry',
        'rating': 4.6,
        'image': 'https://picsum.photos/200?random=13',
      },
    ];
  }

  static List<Map<String, dynamic>> getMockMostlySaled() {
    return [
      {
        'title': 'Golden Mango Twist',
        'flavour': 'Mango',
        'rating': 4.8,
        'image': 'https://picsum.photos/200?random=10',
      },
      {
        'title': 'Fruit Magic Tart',
        'flavour': 'Pineapple, Strawberry',
        'rating': 4.9,
        'image': 'https://picsum.photos/200?random=11',
      },
      {
        'title': 'Lemon Sponge Cake',
        'flavour': 'Lemon',
        'rating': 4.7,
        'image': 'https://picsum.photos/200?random=12',
      },
      {
        'title': 'Mini Cake with Fruits',
        'flavour': 'Mango, Strawberry, Chocolate, Berry',
        'rating': 4.6,
        'image': 'https://picsum.photos/200?random=13',
      },
    ];
  }

  static List<Map<String, dynamic>> getMockProducts() {
    return [
      {'name': 'Rice', 'image': 'https://picsum.photos/200?random=1'},
      {'name': 'Flour', 'image': 'https://picsum.photos/200?random=2'},
      {'name': 'Sugar', 'image': 'https://picsum.photos/200?random=3'},
      {'name': 'Oil', 'image': 'https://picsum.photos/200?random=4'},
      {'name': 'Salt', 'image': 'https://picsum.photos/200?random=5'},
      {'name': 'Pasta', 'image': 'https://picsum.photos/200?random=6'},
    ];
  }

  static List<Offer> getMockOffers() {
    return [
      Offer(
        title: "upto 30% off",
        imageUrls: [
          'assets/images/veg.png',
          'assets/images/banana.png',
          'assets/images/veg.png',
          'assets/images/banana.png',
        ],
        moreCount: 20,
      ),
      Offer(
        title: "buy one get one",
        imageUrls: [
          'assets/images/veg.png',
          'assets/images/banana.png',
          'assets/images/veg.png',
          'assets/images/banana.png', // Bananas
        ],
        moreCount: 15,
      ),
    ];
  }

  static Map<String, dynamic> getAdSectionData() {
    return {
      'brand': {
        'name': 'RAB JEE',
        'tagline': 'feel like home',
        'logo': 'assets/images/veg.png',
      },
      'products': [
        {
          'title': 'Golden Mango Twist',
          'flavour': 'Mango',
          'rating': 4.8,
          'image': 'https://picsum.photos/200?random=14',
        },
        {
          'title': 'Fruit Magic Tart',
          'flavour': 'Pineapple, Strawberry',
          'rating': 4.9,
          'image': 'https://picsum.photos/200?random=15',
        },
        {
          'title': 'Lemon Sponge Cake',
          'flavour': 'Lemon',
          'rating': 4.7,
          'image': 'https://picsum.photos/200?random=16',
        },
        {
          'title': 'Mini Cake with Fruits',
          'flavour': 'Mango, Strawberry, Chocolate, Berry',
          'rating': 4.6,
          'image': 'https://picsum.photos/200?random=17',
        },
      ],
    };
  }

  static Map<String, dynamic> getCategoryPageData(String categoryName) {
    return {
      'backgroundImage': 'https://picsum.photos/600/300?random=60',
      'title': 'CATEGORIES NAME',
      'categories': List.generate(
        8,
        (index) => {
          'name': 'Dry Fruit',
          'image': 'https://picsum.photos/200?random=${70 + index}',
        },
      ),
      'category': categoryName,
      'items': List.generate(
        10,
        (index) => {
          'title': 'Dry Fruit',
          'image': 'https://picsum.photos/200?random=${30 + index}',
        },
      ),
      'subCategoryProducts': [
        {
          'title': 'Golden Mango Twist',
          'flavour': 'Mango',
          'rating': 4.8,
          'image': 'https://picsum.photos/200?random=40',
        },
        {
          'title': 'Fruit Magic Tart',
          'flavour': 'Pineapple, Strawberry',
          'rating': 4.9,
          'image': 'https://picsum.photos/200?random=41',
        },
        {
          'title': 'Lemon Sponge Cake',
          'flavour': 'Lemon',
          'rating': 4.7,
          'image': 'https://picsum.photos/200?random=42',
        },
        {
          'title': 'Mini Cake with Fruits',
          'flavour': 'Mixed Fruits',
          'rating': 4.6,
          'image': 'https://picsum.photos/200?random=43',
        },
      ],
    };
  }
}
