//
//  MainViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

// MARK: - CartProvider Protocol
protocol CartProvider: AnyObject {
    func resetCart()
    func updatePizzaCart(pizzaList: [PizzaModel])
}

// MARK: - MainViewController
/**
 The main view controller of the Pizza App.

 - Note: This class inherits from `UIViewController`.

 */
class MainViewController: UIViewController {

    /// The title label of the view.
    @IBOutlet weak var titleLabel: UILabel!

    /// The table view of the view.
    @IBOutlet weak var tableview: UITableView!

    /// The cart counter label of the view.
    @IBOutlet weak var cartCounterLabel: UILabel!

    /// The presenter used to get data for the view.
    private let presenter = MainPresenter()

    /// The array of pizza models for the view.
    var pizzaArray: [PizzaModel] = []

    /// The array of pizza models in the cart for the view.
    var pizzaCart: [PizzaModel] = []

    /// The pizza model for the view.
    var pizzaModel: PizzaModel?

    /// The array of ingredient models for the view.
    var ingredientsData: [IngredientModel] = []

    /**
     Called after the view controller has loaded its view hierarchy into memory.

     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(mainViewDelegate: self)
        getData()
        configTableView()
        configStrings()
    }

    /**
     Configures the strings of the view.

     */
    func configStrings() {
        titleLabel.text = "Pizza App"
        cartCounterLabel.text = "\(pizzaCart.count)"
    }

    /**
     Configures the table view of the view.

     */
    func configTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "PizzaCell", bundle: nil), forCellReuseIdentifier: "PizzaCell")
    }

    /**
     Gets the data for the view.

     */
    func getData() {
        presenter.getData()
    }

    /**
     Returns the pizza model for the view.

     - Parameter pizza: The pizza model for the view.

     - Returns: The pizza model for the view.

     */
    func returnPizzaModel(pizza: PizzaModel?) -> PizzaModel? {
        return pizzaModel
    }

    /**
     Prepares for the transition to the confirm view.

     - Parameter segue: The segue object containing information about the view controllers involved in the segue.
     - Parameter sender: The object that initiated the segue.

     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfirmSegue" {
            if let destinationVC = segue.destination as? ConfirmViewController {
                destinationVC.pizzasInCart = pizzaCart
                destinationVC.pizzaIngredients = ingredientsData
                destinationVC.cartProvider = self
            }
        }
    }

    /**
     Handles the tap of the cart button.

     - Parameter sender: The object that initiated the tap.

     */
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showConfirmSegue", sender: nil)
    }
}

// MARK: - UITableViewDelegate and UITablewViewDataSouce
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
     Returns the number of rows in the specified section of the table view.

     - Parameter tableView: The table view requesting this information.
     - Parameter section: An index number identifying a section in tableView. Sections are used to group rows with similar characteristics together.
     
     - Returns: The number of rows in section.

     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzaArray.count
    }
    
    /**
     Returns the cell for the corresponding row in the table view.

     - Parameter tableView: The table view requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     
     - Returns: A configured UITableViewCell object.

     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = pizzaArray[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        (cell as? PizzaCell)?.delegate = self
        return cell
    }
    
    /**
     Returns the height of the specified row in the table view.

     - Parameter tableView: The table view object requesting this information.
     - Parameter indexPath: An index path that identifies a row in tableView.
     
     - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be.

     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
}

extension MainViewController: PizzaCellDelegate {
    
    /**
     This method is called when a button is tapped in a PizzaCell. It creates an instance of DetailViewController and sets its properties with the pizza and ingredients data for the selected pizza. It then sets the detailViewControllerDelegate property to self and presents the view controller modally.

     - Parameter cell: The PizzaCell that the user tapped the button in.

     */
    func didTapButton(_ cell: PizzaCell) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        presenter.getPizza(fromList: pizzaArray, withName: cell.pizzaName.text ?? "")
        vc.pizza = pizzaModel
        vc.ingredientsList = ingredientsData
        
        vc.detailViewControllerDelegate = self
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    /**
     This method is called when the "Add to cart" button is tapped in a PizzaCell. It adds the selected pizza to the pizzaCart array.

     - Parameter cell: The PizzaCell that the user tapped the "Add to cart" button in.

     */
    func addToCartButtonTapped(_ cell: PizzaCell) {
        
        if let name = cell.pizzaName.text {
            presenter.addPizzaToCart(from: pizzaArray, with: name)
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    /**
     Set the `pizzaArray` and `ingredientsData` properties with the provided arrays.

     - Parameter pizzas: An array of `PizzaModel` instances to be set as the `pizzaArray` property.
     - Parameter ingredients: An array of `IngredientModel` instances to be set as the `ingredientsData` property.

     */
    func getData(pizzas: [PizzaModel], ingredients: [IngredientModel]) {
        pizzaArray = pizzas
        ingredientsData = ingredients
    }
    
    /**
     Set the `pizzaModel` property with the provided `PizzaModel` instance.

     - Parameter pizzas: The `PizzaModel` instance to be set as the `pizzaModel` property.

     */
    func getPizza(pizza: PizzaModel?) {
        pizzaModel = pizza
    }
    
    /**
     Update the `pizzaCart` property with the provided `PizzaModel` instance and increment the cart counter label.

     - Parameter pizzas: The `PizzaModel` instance to be added to the `pizzaCart` property.

     */
    func updateCart(with pizza: PizzaModel?) {
        if let pizza = pizza {
            var p = pizza
            p.finalView = true
            pizzaCart.append(p)
        }
        cartCounterLabel.text = "\(pizzaCart.count)"
    }
}

extension MainViewController: DetailViewControllerDelegate {
    
    /**
     Add each `PizzaModel` instance in the provided array to the `pizzaCart` property, marking them as a final view, and increment the cart counter label.

     - Parameter pizzas: An array of `PizzaModel?` instances to be added to the `pizzaCart` property.

     */
    func buyPizza(pizzas: [PizzaModel?]) {
        for pizza in pizzas {
            var p = pizza
            p?.finalView = true
            updateCart(with: p)
        }
    }
}

extension MainViewController: CartProvider {
    
    /**
     Reset the `pizzaCart` property to an empty array and update the cart counter label.

     */
    func resetCart() {
        pizzaCart = []
        cartCounterLabel.text = "\(pizzaCart.count)"
    }
    
    /**
     Set the `pizzaCart` property with the provided array of `PizzaModel` instances and update the cart counter label.

     - Parameter pizzaList: An array of `PizzaModel` instances to be set as the `pizzaCart` property.

     */
    func updatePizzaCart(pizzaList: [PizzaModel]) {
        pizzaCart = pizzaList
        cartCounterLabel.text = "\(pizzaCart.count)"
    }
}
