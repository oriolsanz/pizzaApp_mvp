//
//  PizzaCell.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

class PizzaCell: UITableViewCell {
    @IBOutlet weak var pizzaImage: UIImageView!
    @IBOutlet weak var pizzaName: UILabel!
    @IBOutlet weak var customizeButton: UIButton!
    
    weak var delegate: PizzaCellDelegate?
    
    @IBAction func didTapButton(_ sender: UIButton) {
        
        delegate?.didTapButton(self)
    }
}

protocol PizzaCellDelegate: AnyObject {
    func didTapButton(_ cell: PizzaCell)
}

struct PizzaCellModel {
    var pizzaImage: String
    var pizzaName: String
}

class PizzaCellDrawer: DrawerProtocol {
    struct Constants {
        static let reuseID = "PizzaCell"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }

    func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? PizzaCell,
              let item = item as? PizzaCellModel else {
            return
        }
        
        cell.pizzaImage.image = UIImage(named: item.pizzaImage)
        cell.pizzaName.text = item.pizzaName
        
        cell.selectionStyle = .none
    }
}

extension PizzaCellModel: DrawerItemProtocol {
    var cellDrawer: DrawerProtocol {
        return PizzaCellDrawer()
    }

}
