// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class Favorites {
  static final Favorites _favorites = new Favorites._internal();

  Set<WordPair> saved = Set<WordPair>();

  factory Favorites() {
    return _favorites;
  }
  Favorites._internal();
}
final favorites = Favorites();

class SavedWords extends StatefulWidget {
  @override
  SavedWordsState createState() => SavedWordsState();
}

class SavedWordsState extends State<SavedWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = favorites.saved.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: GestureDetector(
            onTap: () async {
              switch (await showDialog(
                  context: context,
                  child: new SimpleDialog(
                    title: new Text(
                        "Tem certeza que deseja excluir esta sugestão?"),
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text("Sim"),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      new SimpleDialogOption(
                        child: new Text("Não"),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      )
                    ],
                  ))) {
                case true:
                  setState(() {
                    favorites.saved.remove(pair);
                  });
                  break;
                case false:
                  break;
              }
            },
            child: Icon(Icons.delete, color: null),
          ),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sugestões Salvas'),
      ),
      body: ListView(children: divided),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SavedWords()
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = favorites.saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            favorites.saved.remove(pair);
          } else {
            favorites.saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Gerador de Nomes')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class MyApp extends StatelessWidget {
  final wordPair = WordPair.random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}
