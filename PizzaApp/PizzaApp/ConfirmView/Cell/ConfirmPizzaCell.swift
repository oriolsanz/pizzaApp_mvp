//
//  ConfirmPizzaCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import Foundation
import UIKit

class ConfirmPizzaCell: UITableViewCell {
    @IBOutlet weak var pizzaImage: UIImageView!
    @IBOutlet weak var pizzaName: UILabel!
    @IBOutlet weak var pizzaIngredients: UILabel!
    
    weak var delegate: ConfirmPizzaCellDelegate?
    
    var ingredientsList: [IngredientModel] = []
    var indexPath: Int = -1
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deletePizza(self)
    }
}

protocol ConfirmPizzaCellDelegate: AnyObject {
    func deletePizza(_ cell: ConfirmPizzaCell)
}

class ConfirmPizzaCellDrawer: DrawerProtocol {
    struct Constants {
        static let reuseID = "ConfirmPizzaCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }
    
    func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? ConfirmPizzaCell,
              let item = item as? PizzaModel else {
            return
        }
        
        cell.pizzaImage.image = UIImage(named: item.pizzaImage)
        cell.pizzaName.text = item.pizzaName
        var ingredientString = ""
        for ingredient in item.pizzaIngredients {
            ingredientString = ingredientString + "- \(getIngredientName(with: ingredient, for: cell))\n"
        }
        ingredientString.removeLast(1)
        cell.pizzaIngredients.text = ingredientString
        
        cell.selectionStyle = .none
    }
    
    func getIngredientName(with id: Int, for cell: ConfirmPizzaCell) -> String {
        for ingredient in cell.ingredientsList {
            if ingredient.ingredientID == id {
                return ingredient.ingredientName
            }
        }
        return ""
    }
}
