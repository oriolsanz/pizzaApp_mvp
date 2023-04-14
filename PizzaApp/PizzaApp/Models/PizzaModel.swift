//
//  PizzaModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

/**
    A model representing a pizza with its name, image, ingredients, and price.
*/
struct PizzaModel: Decodable {
    
    /// The name of the pizza.
    var pizzaName: String
    
    /// The filename of the pizza image.
    var pizzaImage: String
    
    /// An array of integers representing the IDs of the pizza's ingredients.
    var pizzaIngredients: [Int]
    
    /// The price of the pizza.
    var pizzaPrice: Double
    
    /// A boolean value indicating whether the final view of the pizza is being displayed.
    var finalView: Bool = false
    
    /**
        Coding keys used for decoding the `PizzaModel` properties.
    */
    private enum CodingKeys: String, CodingKey {
        case name
        case image
        case ingredients
        case price
    }
    
    /**
        Initializes a new `PizzaModel` instance by decoding the values of the properties from the given decoder.
        
        - Parameter decoder: A decoder to read data from.
        - Throws: An error if any value is missing or not of the expected type.
    */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pizzaName = try values.decode(String.self, forKey: .name)
        pizzaImage = try values.decode(String.self, forKey: .image)
        pizzaIngredients = try values.decode([Int].self, forKey: .ingredients)
        pizzaPrice = try values.decode(Double.self, forKey: .price)
    }
}

/**
    An extension to provide a `DrawerItemProtocol` implementation for `PizzaModel`.
*/
extension PizzaModel: DrawerItemProtocol {
    
    /**
        Returns a `DrawerProtocol` instance for the `PizzaModel` depending on whether the final view of the pizza is being displayed.
        
        - Returns: A `DrawerProtocol` instance.
    */
    var cellDrawer: DrawerProtocol {
        if finalView {
            return ConfirmPizzaCellDrawer()
        }
        return PizzaCellDrawer()
    }
}
