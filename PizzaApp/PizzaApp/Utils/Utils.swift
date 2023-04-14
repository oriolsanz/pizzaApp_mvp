//
//  Utils.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

import Foundation

class Utils {
    
    func getJsonData() -> (pizzas: [PizzaModel], ingredients: [IngredientModel]) {
        
        let path = Bundle.main.path(forResource: "pizzas", ofType: "json")
        if let url = path {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: url))
            let decoder = JSONDecoder()
            
            if let data = jsonData, let root = try? decoder.decode(RootModel.self, from: data) {
                
                return (root.pizzas, root.ingredients)
            }
        }
        return ([], [])
    }
}

// This is needed to avoid the Floating Point on pizza prices
extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
