//
//  Utils.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

import Foundation

/**
    A utility class with useful methods.
*/
class Utils {
    
    /**
     Retrieves pizza and ingredient data from a JSON file.
     
     - Returns: A tuple containing an array of PizzaModel and an array of IngredientModel.
     */
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
    
    /**
    Returns the double value of a decimal number.
    
     - Returns: The double value of the decimal number.
    */
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
