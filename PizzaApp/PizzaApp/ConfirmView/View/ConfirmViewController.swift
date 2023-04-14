//
//  ConfirmViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import UIKit

/**
    A view controller to confirm the user's pizza order and allow them to proceed with the purchase.

    The ConfirmViewController class provides a table view to display the list of pizzas in the user's cart, and allows them to remove pizzas from the cart. It also shows the total amount of the cart and enables the user to proceed with the purchase by tapping the buy button.
*/
class ConfirmViewController: UIViewController {

    /// The table view that displays the list of pizzas in the user's cart.
    @IBOutlet weak var confirmTableView: UITableView!

    /// The button that allows the user to proceed with the purchase.
    @IBOutlet weak var buyButton: UIButton!

    /// The view that contains the confirmation details and the buy button.
    @IBOutlet weak var confirmView: UIView!

    /// The label that is displayed when there are no pizzas in the cart.
    @IBOutlet weak var noItemsLabel: UILabel!

    /// The presenter responsible for handling the business logic of the confirmation view.
    private let presenter = ConfirmPresenter()

    /// The array of `PizzaModel` objects in the user's cart.
    var pizzasInCart: [PizzaModel] = []

    /// The array of `IngredientModel` objects used to display the pizza's ingredients.
    var pizzaIngredients: [IngredientModel] = []

    /// The provider of the cart functionality.
    weak var cartProvider: CartProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(confirmViewDelegate: self)
        presenter.calculateCartAmount(pizzaArray: pizzasInCart)
        configTableView()
        configView()
    }

    /**
     Configures the view by hiding the `confirmView` and showing the `noItemsLabel` if the cart is empty.
     */
    func configView() {
        confirmView.isHidden = true
        
        if pizzasInCart.isEmpty {
            buyButton.isEnabled = false
            noItemsLabel.isHidden = false
        }
    }

    /**
     Configures the table view by setting its delegate and data source, and registering the `ConfirmPizzaCell` nib.
     */
    func configTableView() {
        confirmTableView.delegate = self
        confirmTableView.dataSource = self
        
        confirmTableView.register(UINib(nibName: "ConfirmPizzaCell", bundle: nil), forCellReuseIdentifier: "ConfirmPizzaCell")
    }

    /**
     Shows the `confirmView` when the user taps the buy button.
     
     - Parameter sender: The button that was tapped.
     */
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        confirmView.isHidden = false
    }

    /**
     Dismisses the view controller when the user taps the back button.
     
     - Parameter sender: The button that was tapped.
     */
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    /**
     Dismisses the view controller and resets the cart when the user taps the homepage button.
     
     - Parameter sender: The button that was tapped.
     */
    @IBAction func homepageButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        cartProvider?.resetCart()
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
    Returns the number of rows in the specified section of the table view.

    - Parameter tableView: The table view object requesting this information.
    - Parameter section: An index number identifying a section in the table view.

    - Returns: The number of rows in pizzasInCart array, which is the data source for the table view.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzasInCart.count
    }
    
    /**
     Returns the cell for the corresponding row in the table view.
     - Parameter tableview: the UITableView instance that is requesting the cell.
     - Parameter indexPath: the index path locating the row in the table view.

     - Returns: The cell corresponding to the specified row and indexPath.
    */
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
    
    /**
    Deletes a pizza from the cart.

    - Parameter cell: The cell that contains the pizza to be deleted.
    */
    func deletePizza(_ cell: ConfirmPizzaCell) {
        pizzasInCart.remove(at: cell.indexPath)
        confirmTableView.reloadData()
        presenter.calculateCartAmount(pizzaArray: pizzasInCart)
        cartProvider?.updatePizzaCart(pizzaList: pizzasInCart)
    }
}

extension ConfirmViewController: ConfirmViewDelegate {
    
    /**
    Updates the title of the 'buyButton' with the provided 'amount' parameter by using string interpolation and sets it as the normal state title of the button. The amount is formatted with 2 decimal places.
    
     - Parameter amount: The total amount of the cart to be displayed in the title of the button.
    */
    func getCartAmount(_ amount: Double) {
        buyButton.setTitle("Pay \(String(format: "%.2f", Decimal(floatLiteral: amount).doubleValue))€", for: .normal)
    }
}
