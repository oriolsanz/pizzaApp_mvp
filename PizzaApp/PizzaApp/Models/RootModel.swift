//
//  RootModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

/**
    A struct representing the root object returned by the API containing the list of pizzas and ingredients.
*/
struct RootModel: Decodable {
    
    /// An array of `PizzaModel` objects representing the list of pizzas available.
    let pizzas: [PizzaModel]

    /// An array of `IngredientModel` objects representing the list of ingredients available.
    let ingredients: [IngredientModel]
}
