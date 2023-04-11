//
//  PizzaModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

struct PizzaModel: Decodable {
    var pizzaName: String
    var pizzaImage: String
    var pizzaIngredients: [Int]
    var pizzaPrice: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case image
        case ingredients
        case price
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pizzaName = try values.decode(String.self, forKey: .name)
        pizzaImage = try values.decode(String.self, forKey: .image)
        pizzaIngredients = try values.decode([Int].self, forKey: .ingredients)
        pizzaPrice = try values.decode(Double.self, forKey: .price)
    }
}

extension PizzaModel: DrawerItemProtocol {
    var cellDrawer: DrawerProtocol {
        return PizzaCellDrawer()
    }
}
