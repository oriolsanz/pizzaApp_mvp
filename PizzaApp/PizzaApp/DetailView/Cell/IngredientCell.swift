//
//  IngredientCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 12/4/23.
//

import Foundation
import UIKit

class IngredientCell: UITableViewCell {
    @IBOutlet weak var ingredientQuantity: UILabel!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientPrice: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    
    weak var delegate: IngredientCellDelegate?
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        delegate?.addButtonTapped(self)
    }
    
    @IBAction func substractButtonTapped(_ sender: UIButton) {
        
        delegate?.substractButtonTapped(self)
    }
}

protocol IngredientCellDelegate: AnyObject {
    func addButtonTapped(_ cell: IngredientCell)
    func substractButtonTapped(_ cell: IngredientCell)
}

class IngredientCellDrawer: DrawerProtocol {
    struct Constants {
        static let reuseID = "IngredientCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }
    
    func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? IngredientCell,
              let item = item as? IngredientModel else {
            return
        }
        
        cell.ingredientName.text = item.ingredientName
        cell.ingredientPrice.text = "\(String(format: "%.2f", item.ingredientPrice))€"
        
        cell.selectionStyle = .none
    }
}
