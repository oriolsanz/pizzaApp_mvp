//
//  PizzaCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

// MARK: - PizzaCell
/**
 A custom table view cell to display a pizza image, name, and buttons for customization and adding to cart.

 - Note: This cell requires a delegate that conforms to the `PizzaCellDelegate` protocol.

 */
class PizzaCell: UITableViewCell {

    /// The image view for displaying the pizza image.
    @IBOutlet weak var pizzaImage: UIImageView!

    /// The label for displaying the pizza name.
    @IBOutlet weak var pizzaName: UILabel!

    /// The button for initiating customization of the pizza.
    @IBOutlet weak var customizeButton: UIButton!

    /// The button for adding the pizza to the cart.
    @IBOutlet weak var addToCartButton: UIButton!

    /// The delegate for handling button taps and other events.
    weak var delegate: PizzaCellDelegate?

    /**
     The action to perform when the customize button is tapped.

     - Parameter sender: The button that initiated the action.
     */
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.didTapButton(self)
    }

    /**
     The action to perform when the add to cart button is tapped.

     - Parameter sender: The button that initiated the action.
     */
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        delegate?.addToCartButtonTapped(self)
    }

}


// MARK: - PizzaCellDelegate
protocol PizzaCellDelegate: AnyObject {
    func didTapButton(_ cell: PizzaCell)
    func addToCartButtonTapped(_ cell: PizzaCell)
}

// MARK: - PizzaCellDrawer
/**
 A drawer object that draws pizza cells in a table view.

 - Note: This class conforms to the `DrawerProtocol` protocol.

 */
class PizzaCellDrawer: DrawerProtocol {

    /**
     A struct that contains constants used in the class.

     - Note: The `reuseID` constant is used to identify the reuse identifier for the pizza cell.

     */
    struct Constants {
        static let reuseID = "PizzaCell"
    }

    /**
     Configures and returns a cell for the specified index path.

     - Parameter tableView: The table view requesting the cell.
     - Parameter indexPath: The index path of the cell.

     - Returns: A configured table view cell.

     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }

    /**
     Draws the specified item in the specified cell.

     - Parameter cell: The cell to draw.
     - Parameter item: The item to draw in the cell.

     */
    func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? PizzaCell,
              let item = item as? PizzaModel else {
            return
        }
        
        cell.pizzaImage.image = UIImage(named: item.pizzaImage)
        cell.pizzaName.text = item.pizzaName
        
        cell.selectionStyle = .none
    }
}

