//
//  ConfirmViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var confirmTableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var noItemsLabel: UILabel!
    
    private let presenter = ConfirmPresenter()
    
    var pizzasInCart: [PizzaModel] = []
    var pizzaIngredients: [IngredientModel] = []
    
    weak var cartProvider: CartProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(confirmViewDelegate: self)
        presenter.calculateCartAmount(pizzaArray: pizzasInCart)
        configTableView()
        configView()
    }
    
    func configView() {
        confirmView.isHidden = true
        
        if pizzasInCart.isEmpty {
            buyButton.isEnabled = false
            noItemsLabel.isHidden = false
        }
    }
    
    func configTableView() {
        
        confirmTableView.delegate = self
        confirmTableView.dataSource = self
        
        confirmTableView.register(UINib(nibName: "ConfirmPizzaCell", bundle: nil), forCellReuseIdentifier: "ConfirmPizzaCell")
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        confirmView.isHidden = false
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func homepageButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        cartProvider?.resetCart()
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzasInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = pizzasInCart[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? ConfirmPizzaCell {
            cell.ingredientsList = pizzaIngredients
            cell.indexPath = indexPath.row
            drawer.drawCell(cell, withItem: item)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension ConfirmViewController: ConfirmPizzaCellDelegate {
    
    func deletePizza(_ cell: ConfirmPizzaCell) {
        pizzasInCart.remove(at: cell.indexPath)
        confirmTableView.reloadData()
        presenter.calculateCartAmount(pizzaArray: pizzasInCart)
        cartProvider?.updatePizzaCart(pizzaList: pizzasInCart)
    }
}

extension ConfirmViewController: ConfirmViewDelegate {
    
    func getCartAmount(_ amount: Double) {
        buyButton.setTitle("Pay \(String(format: "%.2f", Decimal(floatLiteral: amount).doubleValue))€", for: .normal)
    }
}
