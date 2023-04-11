//
//  RootModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

struct RootModel: Decodable {
    let pizzas: [PizzaModel]
    let ingredients: [IngredientModel]
}
