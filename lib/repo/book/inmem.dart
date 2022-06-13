import 'package:le_bon_mot/model/book.dart';
import 'package:le_bon_mot/model/quote.dart';
import 'package:le_bon_mot/repo/book/book.dart';

class InMemBookRepository implements BookRepository {
  final savedBooks = <Book>[
    Book(
        id: "abc",
        authors: ["Mike Horn"],
        title: "Survivant des glaces",
        subtitle: "L'ultime challenge : la traversée du pôle Nord",
        pageCount: 333,
        thumbnail:
            "http://books.google.com/books/content?id=PwlBEAAAQBAJ&printsec=frontcover&zoom=1&img=1&source=gbs_api",
        quotes: [
          Quote(
            fullText:
                "Dans une précipitation, une fébrilité qui me sont étrangères, je commets un faux pas qui aurait pu se révéler funeste... L'erreur n'est pas une option dans la vie que je mène depuis une trentaine d'années, cette fois elle condamne mon imprudence.",
            page: 33,
            dateAdded: DateTime.now(),
            hashTags: ["Adventure", "Exploration", "Survivalist"]
          ),
          Quote(
            fullText:
              "Il aura pourtant suffi d’un rien pour que l’image que j’avais de moi-même ne se fendille dans le silence hostile d’un bout du monde, pour que les formidables capacités de surhomme que je me prêtais ne s’évanouissent comme des illusions perdues… ",
            page: 271,
            dateAdded: DateTime.now(),
            hashTags: ["Adventure", "Fear"],
          )
        ]),
    Book(
        id: "efg",
        authors: ["Bernard Werber"],
        title: "Les fourmis",
        pageCount: 354,
        thumbnail:
            "http://books.google.com/books/content?id=YHAGLByIK7oC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
      quotes: [],
    )
  ];

  final externalBooks = <Book>[
    Book(
        id: "hij",
        authors: ["Fédor Dostoïevski"],
        quotes: [],
        title: "Les pauvres gens",
        pageCount: 208,
        thumbnail:
            "http://books.google.com/books/content?id=fJQiEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"),
    Book(
        id: "efg",
        authors: ["Bernard Werber"],
        quotes: [],
        title: "Les fourmis",
        pageCount: 354,
        thumbnail:
            "http://books.google.com/books/content?id=YHAGLByIK7oC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"),
    Book(
        id: "abc",
        authors: ["Mike Horn"],
        quotes:  [],
        title: "Survivant des glaces",
        subtitle: "L'ultime challenge : la traversée du pôle Nord",
        pageCount: 333,
        thumbnail:
            "http://books.google.com/books/content?id=PwlBEAAAQBAJ&printsec=frontcover&zoom=1&img=1&source=gbs_api"),
  ];

  @override
  Future<List<Book>> searchForNewBooks(String search) async {
    return externalBooks
        .where((b) => b.title.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  @override
  Future<List<Book>> searchSavedBooks(String search) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (search == "") return savedBooks;
    return savedBooks
        .where((b) => b.title.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}
