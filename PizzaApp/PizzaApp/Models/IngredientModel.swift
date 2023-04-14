//
//  IngredientModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

/**
 A model representing an ingredient with its properties.
 - Parameters:
    - ingredientID: An integer representing the unique identifier of the ingredient.
    - ingredientName: A string representing the name of the ingredient.
    - ingredientPrice: A double representing the price of the ingredient.
    - ingredientQuantity: An integer representing the quantity of the ingredient (defaults to 0).
 
 - Note: Conforms to Decodable protocol to enable decoding the JSON response from the server.
 
 - Note: Conforms to DrawerItemProtocol to be used as an item to populate a table view cell.
 */
struct IngredientModel: Decodable {
    var ingredientID: Int
    var ingredientName: String
    var ingredientPrice: Double
    var ingredientQuantity: Int = 0
    
    /**
        A coding key enum to map the properties of the model to the keys in the JSON response.
    */
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
    }
    
    /**
     Initializes a new instance of IngredientModel by decoding from the given decoder.
     - Parameters:
        - decoder: A decoder to read data from.
     
     - Throws: DecodingError if the given decoder is unable to decode the required properties.
     */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ingredientID = try values.decode(Int.self, forKey: .id)
        ingredientName = try values.decode(String.self, forKey: .name)
        ingredientPrice = try values.decode(Double.self, forKey: .price)
        ingredientQuantity = 0
    }
}

/**
    An extension of IngredientModel to conform to DrawerItemProtocol and enable drawing the model in a table view cell.
*/
extension IngredientModel: DrawerItemProtocol {
    /*
        Returns an instance of IngredientCellDrawer to draw the model in a table view cell.
    */
    var cellDrawer: DrawerProtocol {
        return IngredientCellDrawer()
    }
}
