//
//  IngredientCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 12/4/23.
//

import Foundation
import UIKit

/**
    The IngredientCell class defines a custom table view cell for displaying an ingredient in the PizzaApp. It contains outlets for the ingredient quantity, name, price, and add/substract buttons. It also declares a weak delegate of type IngredientCellDelegate, and implements methods for tapping the add/substract buttons.
*/
class IngredientCell: UITableViewCell {
    /// The label displaying the quantity of the ingredient.
    @IBOutlet weak var ingredientQuantity: UILabel!

    /// The label displaying the name of the ingredient.
    @IBOutlet weak var ingredientName: UILabel!

    /// The label displaying the price of the ingredient.
    @IBOutlet weak var ingredientPrice: UILabel!

    /// The button used to add the ingredient to a pizza.
    @IBOutlet weak var addButton: UIButton!

    /// The button used to substract the ingredient from a pizza.
    @IBOutlet weak var substractButton: UIButton!

    /// The delegate used to handle button tap events.
    weak var delegate: IngredientCellDelegate?

    /**
     Called when the add button is tapped.
     - Parameter sender: The UIButton that triggered the event.
     */
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        delegate?.addButtonTapped(self)
    }
    
    /**
     Called when the substract button is tapped.
     - Parameter sender: The UIButton that triggered the event.
     */
    @IBAction func substractButtonTapped(_ sender: UIButton) {
        
        delegate?.substractButtonTapped(self)
    }
}

/**
    The IngredientCellDelegate protocol declares methods that are implemented by a delegate of the IngredientCell class, which handles button tap events.
*/
protocol IngredientCellDelegate: AnyObject {
    
    /**
     Called when the add button is tapped.
     - Parameter cell: The IngredientCell that contains the add button.
     */
    func addButtonTapped(_ cell: IngredientCell)

    /**
     Called when the substract button is tapped.
     - Parameter cell: The IngredientCell that contains the substract button.
     */
    func substractButtonTapped(_ cell: IngredientCell)
}

/**
    The IngredientCellDrawer class implements the DrawerProtocol and defines methods for drawing an IngredientCell instance in a UITableView. It contains a struct with the reuse identifier of the cell.
*/
class IngredientCellDrawer: DrawerProtocol {
    
    /**
     A struct containing the reuse identifier of the cell.
     */
    struct Constants {
        static let reuseID = "IngredientCell"
    }
    
    /**
     Creates and returns a table view cell with the reuse identifier "IngredientCell".
     - Parameters:
        - tableView: The UITableView in which to display the cell.
        - indexPath: The index path of the cell.
     - Returns: An IngredientCell instance.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }
    
    /**
     Configures an IngredientCell instance with an IngredientModel instance.
     - Parameters:
        - cell: The IngredientCell to be configured.
        - item: The IngredientModel to be displayed in the cell.
     */
    func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? IngredientCell,
              let item = item as? IngredientModel else {
            return
        }
        
        cell.ingredientName.text = item.ingredientName
        cell.ingredientPrice.text = "\(String(format: "%.2f", item.ingredientPrice))€"
        cell.ingredientQuantity.text = "\(item.ingredientQuantity)"
        
        if item.ingredientQuantity > 0 {
            cell.contentView.backgroundColor = UIColor(red: 114/255, green: 204/255, blue: 229/255, alpha: 0.2)
        } else {
            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        }
        
        cell.selectionStyle = .none
    }
}
