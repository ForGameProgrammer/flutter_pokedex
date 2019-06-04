import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Entities/pokemon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = "Flutter Pokedex";
    return MaterialApp(
      title: title,
      theme: ThemeData.dark(),
      home: MyHomePage(title: title),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 800,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future: Pokemon.getPokemonForId(index + 1),
            builder: (BuildContext ctx, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Text("Hata! API");
                }
                return snapshot.data.createListTile(ctx);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return Card(
                child: ListTile(
                  title: Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              );
            },
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsPage({Key key, this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.getReadableName()),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Hero(
                  tag: pokemon.name,
                  child: Image.network(
                    pokemon.spriteUrl,
                    scale: 0.50,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: pokemon.stats.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return pokemon.stats[index].getListTile(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
