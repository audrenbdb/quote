class Quote {
  String fullText;
  DateTime dateAdded;
  List<String> hashTags;
  int page;

  Quote({
    required this.fullText,
    required this.dateAdded,
    required this.page,
    this.hashTags = const [],
  });
}
