//
//  DetailViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

protocol DetailViewControllerDelegate {
    func buyPizza(pizzas: [PizzaModel?])
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pizzaNameLabel: UILabel!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var pizza: PizzaModel?
    var ingredientsList: [IngredientModel] = []
    var detailViewControllerDelegate: DetailViewControllerDelegate?
    
    private let presenter = DetailPresenter()
    
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
            ingredientsList = presenter.getPizzaIngredients(fromPizza: pizza, withIngredients: ingredientsList)
            ingredientsTableView.reloadData()
        }
    }
    
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
    
    func configTableView() {
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        ingredientsTableView.register(UINib(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "IngredientCell")
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        detailViewControllerDelegate?.buyPizza(pizzas: presenter.getPizzas())
        self.dismiss(animated: true)
    }
    
    @objc func minusLabelTapped() {
        presenter.substractPizza()
    }
    
    @objc func plusLabelTapped() {
        presenter.addPizza()
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = ingredientsList[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        (cell as? IngredientCell)?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension DetailViewController: IngredientCellDelegate {
    
    func addButtonTapped(_ cell: IngredientCell) {
        if let price = cell.ingredientPrice.text {
            ingredientsList = presenter.addPrice(value: price, toIngredient: cell.ingredientName.text ?? "", fromIngredientsList: ingredientsList)
            ingredientsTableView.reloadData()
        }
    }
    
    func substractButtonTapped(_ cell: IngredientCell) {
        if let price = cell.ingredientPrice.text {
            ingredientsList = presenter.substractPrice(value: price, toIngredient: cell.ingredientName.text ?? "", fromIngredientsList: ingredientsList)
            ingredientsTableView.reloadData()
        }
    }
}

extension DetailViewController: DetailViewDelegate {
    
    func updatePizzaPrice(newPrice: Double) {
        ingredientsTableView.reloadData()
        addToCartButton.setTitle("Add \(String(format: "%.2f", newPrice))€", for: .normal)
    }
    
    func updatePizzaNumber(newValue: Int) {
        numberLabel.text = "\(newValue)"
    }
}
