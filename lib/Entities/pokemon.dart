import 'dart:convert';
import 'package:flutter_pokedex/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/Entities/stat.dart';

const String POKEMON_API_URL = "https://pokeapi.co/api/v2/pokemon/\$/";

class Pokemon {
  final String name;
  final String body;
  final int weight;
  final int height;
  final int id;
  final String spriteUrl;
  final List<Stat> stats;
  final Image image;

  Pokemon(
      {this.image,
      this.height,
      this.stats,
      this.name,
      this.body,
      this.weight,
      this.id,
      this.spriteUrl});

  String getReadableName() {
    String nameString = name;
    nameString = nameString.substring(0, 1).toUpperCase() +
        nameString.substring(1, nameString.length);
    nameString = nameString.replaceAll("-", " ");
    return nameString;
  }

  Widget createListTile(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PokemonDetailsPage(pokemon: this)),
          );
        },
        title: Text(
          getReadableName(),
          style: Theme.of(context).textTheme.title,
        ),
        leading: Hero(
          tag: name,
          child: image,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  static Future<Pokemon> getPokemonForId(int id) async {
    final response =
        await http.get(POKEMON_API_URL.replaceAll("\$", id.toString()));
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<Stat> stats = List<Stat>();
    if (json['stats'] != null) {
      json['stats'].forEach((value) {
        Stat stat = Stat.fromJson(value);
        stats.add(stat);
      });
    }

    return Pokemon(
      name: json['name'],
      body: json['body'],
      weight: json['weight'],
      id: json['id'],
      spriteUrl: json['sprites']['front_default'],
      stats: stats,
      height: json['height'],
      image: Image.network(json['sprites']['front_default']),
    );
  }
}
