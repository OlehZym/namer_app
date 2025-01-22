import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(
              //seedColor: const Color.fromARGB(255, 225, 0, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  // current = WordPair.random();
  // notifyListeners();

  var favorites = <WordPair>[];
  var redColor = const Color.fromARGB(255, 243, 33, 33);

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
   //  var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

     // The container for the current page, with its background color
    // and subtle switching animation.
    var redColor = const Color.fromARGB(255, 255, 0, 0);
    var blackColor = const Color.fromARGB(255, 0, 0, 0);
    var mainArea = ColoredBox(
      color: const Color.fromARGB(255, 156, 171, 255),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );


      return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home,),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite,  color: redColor),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home, color: const Color.fromARGB(255, 27, 143, 12)),
                        label: Text('Home',
                        style: TextStyle(
                         color:blackColor,
                         fontSize: 14,
                         fontWeight: FontWeight.w600
                       ),
                     ),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite, color: redColor),
                        label: Text('Favorites',
                         style: TextStyle(
                          color:blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var redColor = const Color.fromARGB(255, 255, 0, 0);
    var greenColor = const Color.fromARGB(255, 18, 90, 0);

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Namer App'),
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10), 
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               OutlinedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon, color: redColor),
                label: Text(
                  'Like',
                  style: TextStyle(
                    color: redColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 250, 201, 201), // Цвет фона
                  side: const BorderSide(
                    color: Color.fromARGB(255, 243, 33, 33), // Цвет рамки
                    width: 1, // Толщина рамки
                  ),
                ),
              ),
              SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  appState.getNext();
                },
                icon: Icon(Icons.keyboard_double_arrow_right, color: const Color.fromARGB(255, 18, 90, 0)),
                label: Text(
                  'Next',
                  style: TextStyle(
                    color:greenColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 127, 252, 122), // Цвет фона
                  side: const BorderSide(
                    color: Color.fromARGB(255, 11, 94, 0), // Цвет рамки
                    width: 1, // Толщина рамки
                  ),
                ),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
       super.key,
    required this.pair,
  });

   // super.key,
   // required this.pair,
  //});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var greenColor = const Color.fromARGB(255, 27, 94, 1);
    var style = theme.textTheme.displayMedium!.copyWith(
      color:  const Color.fromARGB(255, 255, 255, 255),
    );

    return Card(
      color:  greenColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:  AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style:
                   style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//Text(
//          pair.asPascalCase,
//          style: style,
//          semanticsLabel: pair.asPascalCase,
//        ),
//      ),
//    );
//  }
//}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  //  var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var blackColor = const Color.fromARGB(255, 0, 0, 0);

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.',
        style: TextStyle(
         color:blackColor,
         fontSize: 20
                  ),),
      );
    }

  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:',
              style: TextStyle(
                    color:blackColor,
                    fontSize: 20
                    ),
                  ),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: blackColor,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                    style: TextStyle(
                    color:blackColor,
                    fontSize: 20
                  ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;
    var redColor = const Color.fromARGB(255, 255, 0, 0);

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite,color:  redColor, size: 12, )
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                  style: TextStyle(
                    color:const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

  //  return ListView(
    //  children: [
    //    Padding(
     //     padding: const EdgeInsets.all(20),
    //      child: Text('You have '
     //         '${appState.favorites.length} favorites:'),
     //   ),
    //    for (var pair in appState.favorites)
    //      ListTile(
     //       leading: Icon(Icons.favorite),
     //       title: Text(pair.asLowerCase),
     //     ),
    //  ],
   // );
 // }
//}
