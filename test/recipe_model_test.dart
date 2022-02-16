import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app_flutter/models/Recipe.dart';
import 'package:recipe_app_flutter/models/Ingredient.dart';

void main() {
  var _IngredientJson = [
    {'_id': '1', 'name': 'Rice'},
    {'_id': '2', 'name': 'Dal'},
    {'_id': '3', 'name': 'Flour'},
  ];

  var tags = ['Dinner', 'Food'];

  var _ingredientModels = [
    Ingredient(id: "1", name: 'Rice'),
    Ingredient(id: "2", name: 'Dal'),
    Ingredient(id: "3", name: 'Flour'),
  ];
  group('fromJson', () {
    test(
      'GIVEN a valid Recipe json '
      'WHEN a json deserialization is performed'
      'THEN a Ingredient model is output',
      () {
        //given
        final data = {
          '_id': '1',
          'author': {'display': 'nam', '_id': '1'},
          'name': 'newRecipe',
          'ingredients': _IngredientJson,
          'directions': 'this and that',
          'tags': tags,
          'image': 'nonono',
          'serves': 5,
          'isLiked': true,
          'numFavorites': 3,
          'numHits': 5
        };

        //when
        final actual = Recipe.fromJson(data);
        var matcher = Recipe(
            recipeId: '1',
            author: 'Unknown',
            authorId: '',
            name: "newRecipe",
            ingredients: _ingredientModels,
            directions: "this and that",
            tags: tags,
            image: "nonono",
            serves: 5,
            isLiked: true,
            favorites: 3,
            hits: 5);

        //then
        expect(actual, matcher);
      },
    );
  });

  group("RecipeAsString", () {
    test(
        'GIVEN a Recipe model with Recipe id '
        'WHEN a Recipe is sent '
        'THEN a Recipe string is a result', () {
      //given
      var recipe = Recipe(
          recipeId: '1',
          author: 'Unknown',
          authorId: '',
          name: "newRecipe",
          ingredients: _ingredientModels,
          directions: "this and that",
          tags: tags,
          image: "nonono",
          serves: 5,
          isLiked: true,
          favorites: 3,
          hits: 5);

      //when
      final actual = recipe.recipeAsString();
      final matcher = "#1 newRecipe";

      //then
      expect(actual, matcher);
    });
  });

  group('Equality', () {
    test(
      'GIVEN two Recipe models '
      'WHEN properties are different '
      'THEN equality returns false',
      () {
        //given
        var recipe1 = Recipe(
            recipeId: '2',
            author: 'Unkn1own',
            authorId: '',
            name: "newRec1ipe",
            ingredients: _ingredientModels,
            directions: "this 1and that",
            tags: tags,
            image: "non1ono",
            serves: 51,
            isLiked: true,
            favorites: 31,
            hits: 51);

        //when
        var recipe2 = Recipe(
            recipeId: '1',
            author: 'Unknown',
            authorId: '',
            name: "newRecipe",
            ingredients: _ingredientModels,
            directions: "this and that",
            tags: tags,
            image: "nonono",
            serves: 5,
            isLiked: true,
            favorites: 3,
            hits: 5);

        //then
        expect(recipe1 == recipe2, false);
      },
    );

    test(
      'GIVEN two user models '
      'WHEN properties are same '
      'THEN equality returns true',
      () {
        //given
        var recipe1 = Recipe(
            recipeId: '1',
            author: 'Unknown',
            authorId: '',
            name: "newRecipe",
            ingredients: _ingredientModels,
            directions: "this and that",
            tags: tags,
            image: "nonono",
            serves: 5,
            isLiked: true,
            favorites: 3,
            hits: 5);

        //when
        var recipe2 = Recipe(
            recipeId: '1',
            author: 'Unknown',
            authorId: '',
            name: "newRecipe",
            ingredients: _ingredientModels,
            directions: "this and that",
            tags: tags,
            image: "nonono",
            serves: 5,
            isLiked: true,
            favorites: 3,
            hits: 5);

        //then
        expect(recipe1 == recipe2, true);
      },
    );
  });
}
