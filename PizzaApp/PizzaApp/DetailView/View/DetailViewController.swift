//
//  DetailViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

/**
    This protocol defines the methods that a DetailViewControllerDelegate must implement.
*/
protocol DetailViewControllerDelegate {
    
    /**
     Function called when a user taps on the "buy" button.
     
     - Parameters:
        - pizzas: An array of PizzaModel objects representing the pizzas to be purchased. It may contain nil values in case an error occurs.
     */
    func buyPizza(pizzas: [PizzaModel?])
}

/**
    A view controller that displays the details of a pizza, including its name, image, ingredients, and price, and allows the user to add it to the cart.
*/
class DetailViewController: UIViewController {
    
    /// The label that displays the name of the pizza.
    @IBOutlet weak var pizzaNameLabel: UILabel!

    /// The image view that displays the image of the pizza.
    @IBOutlet weak var pizzaImageView: UIImageView!

    /// The button that takes the user back to the previous screen.
    @IBOutlet weak var backButton: UIButton!

    /// The label that displays the list of ingredients of the pizza.
    @IBOutlet weak var ingredients: UILabel!

    /// The table view that displays the ingredients of the pizza.
    @IBOutlet weak var ingredientsTableView: UITableView!

    /// The label that represents the minus sign.
    @IBOutlet weak var minusLabel: UILabel!

    /// The label that displays the quantity of the pizza.
    @IBOutlet weak var numberLabel: UILabel!

    /// The label that represents the plus sign.
    @IBOutlet weak var plusLabel: UILabel!

    /// The button that adds the pizza to the cart.
    @IBOutlet weak var addToCartButton: UIButton!

    /// The pizza that is displayed on this view controller.
    var pizza: PizzaModel?

    /// The list of ingredients of the pizza that is displayed on this view controller.
    var ingredientsList: [IngredientModel] = []

    /// The delegate that handles events related to this view controller.
    var detailViewControllerDelegate: DetailViewControllerDelegate?

    /// The presenter that handles the business logic of this view controller.
    private let presenter = DetailPresenter()
    
    /**
     Called after the view controller has loaded its view hierarchy into memory.

     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configTableView()
        presenter.setViewDelegate(detailViewDelegate: self)
        
        if let pizza = pizza {
            presenter.setPizza(pizza)
            presenter.pizzaPrice = pizza.pizzaPrice
            updatePizzaPrice(newPrice: pizza.pizzaPrice)
        }
        
        if let pizza = pizza {
            presenter.getPizzaIngredients(fromPizza: pizza, withIngredients: ingredientsList)
        }
    }
    
    /**
     This method configures the view elements of the detail view.
     */
    func configView() {
        
        backButton.setTitle("< Back", for: .normal)
        pizzaNameLabel.text = pizza?.pizzaName
        pizzaImageView.image = UIImage(named: pizza?.pizzaImage ?? "")
        ingredients.text = "Ingredientes:"
        numberLabel.text = "1"
        
        minusLabel.isUserInteractionEnabled = true
        minusLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minusLabelTapped)))
        
        plusLabel.isUserInteractionEnabled = true
        plusLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusLabelTapped)))
    }
    
    /**
     This method configures the table view of the detail view.
     */
    func configTableView() {
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        ingredientsTableView.register(UINib(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "IngredientCell")
    }
    
    /**
     This method is called when the back button is tapped.
     */
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /**
     This method is called when the buy button is tapped.
     */
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        presenter.getPizzas()
    }
    
    /**
     This method is called when the minus label is tapped.
     */
    @objc func minusLabelTapped() {
        presenter.substractPizza()
    }
    
    /**
     This method is called when the plus label is tapped.
     */
    @objc func plusLabelTapped() {
        presenter.addPizza()
    }
}

/**
    This extension implements the UITableViewDelegate and UITableViewDataSource protocols.
*/
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
     Returns the number of rows in the specified section.
     
     - Parameters:
        - tableView: A table view object requesting this information.
        - section: An index number identifying a section of tableView.
     
     - Returns: The number of rows in section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameters:
        - tableView: A table view object requesting the cell.
        - indexPath: An index path locating the row in tableView.
     
     - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if nil is returned.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = ingredientsList[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        (cell as? IngredientCell)?.delegate = self
        return cell
    }
    
    /**
     Asks the delegate for the height to use for a row in a specified location.
     
     - Parameters:
        - tableView: A table view object requesting the cell.
        - indexPath: An index path locating the row in tableView.
     
     - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be. The height must be greater than 0.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension DetailViewController: IngredientCellDelegate {
    
    /**
     This function is called when the add button is tapped on an IngredientCell.
     
     - Parameters:
        - cell: The cell on which the add button was tapped.
     */
    func addButtonTapped(_ cell: IngredientCell) {
        if let price = cell.ingredientPrice.text {
            presenter.addPrice(value: price, toIngredient: cell.ingredientName.text ?? "", fromIngredientsList: ingredientsList)
        }
    }
    
    /**
     This function is called when the subtract button is tapped on an IngredientCell.
     
     - Parameters:
        - cell: The cell on which the subtract button was tapped.
     */
    func substractButtonTapped(_ cell: IngredientCell) {
        if let price = cell.ingredientPrice.text {
            presenter.substractPrice(value: price, toIngredient: cell.ingredientName.text ?? "", fromIngredientsList: ingredientsList)
        }
    }
}

extension DetailViewController: DetailViewDelegate {
    
    /**
     Updates the pizza price and refreshes the ingredients table view and add to cart button.

     - Parameter newPrice: The new price of the pizza.
     */
    func updatePizzaPrice(newPrice: Double) {
        ingredientsTableView.reloadData()
        addToCartButton.setTitle("Add \(String(format: "%.2f", newPrice))€", for: .normal)
    }

    /**
     Updates the number of pizzas.

     - Parameter newValue: The new number of pizzas.
     */
    func updatePizzaNumber(newValue: Int) {
        numberLabel.text = "\(newValue)"
    }

    /**
     Gets the list of pizzas and notifies the delegate to buy the pizzas.

     - Parameter pizzaList: The list of pizzas.
     */
    func getPizzaList(pizzaList: [PizzaModel?]) {
        detailViewControllerDelegate?.buyPizza(pizzas: pizzaList)
        self.dismiss(animated: true)
    }

    /**
     Gets the list of ingredients and updates the ingredients table view.

     - Parameter ingredientList: The list of ingredients.
     */
    func getIngredientList(ingredientList: [IngredientModel]) {
        ingredientsList = ingredientList
        ingredientsTableView.reloadData()
    }
}
