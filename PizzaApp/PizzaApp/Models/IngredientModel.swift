//
//  IngredientModel.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 11/4/23.
//

struct IngredientModel: Decodable {
    var ingredientID: Int
    var ingredientName: String
    var ingredientPrice: Double
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ingredientID = try values.decode(Int.self, forKey: .id)
        ingredientName = try values.decode(String.self, forKey: .name)
        ingredientPrice = try values.decode(Double.self, forKey: .price)
        isSelected = false
    }
}

extension IngredientModel: DrawerItemProtocol {
    var cellDrawer: DrawerProtocol {
        return IngredientCellDrawer()
    }
}
