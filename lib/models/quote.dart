enum Rarities {
  COMMON,
  RARE,
  EPIC,
  LEGENDARY,
}

class Quote {
  final quote;
  final author;
  final isInCollection;
  final isFavorite;
  final rarity;

  Quote({
    this.quote,
    this.author,
    this.isInCollection,
    this.isFavorite,
    this.rarity,
  });
}
