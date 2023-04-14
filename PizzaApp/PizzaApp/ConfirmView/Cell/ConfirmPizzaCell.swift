//
//  ConfirmPizzaCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import Foundation
import UIKit

/**
This class represents the table view cell used for displaying a pizza in the cart confirmation screen.
*/
class ConfirmPizzaCell: UITableViewCell {
    
    /// The image view displaying the pizza image.
    @IBOutlet weak var pizzaImage: UIImageView!
    
    /// The label displaying the pizza name.
    @IBOutlet weak var pizzaName: UILabel!
    
    /// The label displaying the pizza ingredients.
    @IBOutlet weak var pizzaIngredients: UILabel!
    /// The delegate object responsible for handling cell deletion.
    weak var delegate: ConfirmPizzaCellDelegate?

    /// The list of ingredients for the pizza.
    var ingredientsList: [IngredientModel] = []
    /// The index path of the cell.
    var indexPath: Int = -1

    /**
     Called when the delete button is tapped. Notifies the delegate object to delete the cell.
     
     - Parameter sender: The delete button that was tapped.
     */
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deletePizza(self)
    }
}

/**
This protocol defines the methods that the delegate of the ConfirmPizzaCell should implement.
*/
protocol ConfirmPizzaCellDelegate: AnyObject {
    
    /**
     Notifies the delegate that the specified cell should be deleted.
     
     - Parameter cell: The cell that should be deleted.
     */
    func deletePizza(_ cell: ConfirmPizzaCell)
}

/**
This class is responsible for drawing a ConfirmPizzaCell object for a specified PizzaModel object.
*/
class ConfirmPizzaCellDrawer: DrawerProtocol {
    
    /// The constants used in the class.
    struct Constants {
        static let reuseID = "ConfirmPizzaCell"
    }
    
    /**
     Returns a new or reusable `ConfirmPizzaCell` object for the specified index path of the table view.
     
     - Parameters:
        - tableView: The table view that will display the cell.
        - indexPath: The index path of the cell.
     
     - Returns: The created or reusable cell object.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }
    
    /**
     Draws the specified `PizzaModel` object to the specified `ConfirmPizzaCell` object.
     
     - Parameters:
        - cell: The cell that should be drawn.
        - item: The pizza model object that should be drawn.
     */
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
    
    /**
     Returns the name of the ingredient with the specified ID for the specified cell.
     
     - Parameters:
        - id: The ID of the ingredient.
        - cell: The cell containing the ingredients list.
     
     - Returns: The name of the ingredient.
     */
    func getIngredientName(with id: Int, for cell: ConfirmPizzaCell) -> String {
        for ingredient in cell.ingredientsList {
            if ingredient.ingredientID == id {
                return ingredient.ingredientName
            }
        }
        return ""
    }
}
