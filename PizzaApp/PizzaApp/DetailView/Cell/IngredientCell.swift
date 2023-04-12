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
        cell.ingredientQuantity.text = "\(item.ingredientQuantity)"
        
        if item.ingredientQuantity > 0 {
            cell.contentView.backgroundColor = UIColor(red: 114/255, green: 204/255, blue: 229/255, alpha: 0.2)
        } else {
            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        }
        
        cell.selectionStyle = .none
    }
}
