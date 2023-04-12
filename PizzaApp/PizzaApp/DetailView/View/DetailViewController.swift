//
//  DetailViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

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
    var pizzaIngredients: [IngredientModel] = []
    
    private let presenter = DetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        configTableView()
        presenter.setViewDelegate(detailViewDelegate: self)
        
        if let price = pizza?.pizzaPrice {
            presenter.pizzaPrice = price
            updatePizzaPrice(newPrice: price)
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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO add view
        print(sender.currentTitle)
    }
    
    @objc func minusLabelTapped() {
        if numberLabel.text != "1" {
            if let price = pizza?.pizzaPrice {
                presenter.substractPrice(value: "\(price)")
                numberLabel.text = "\((Int(numberLabel.text ?? "1") ?? 1) - 1)"
            }
        }
    }
    
    @objc func plusLabelTapped() {
        if let price = pizza?.pizzaPrice {
            presenter.addPrice(value: "\(price)")
            numberLabel.text = "\((Int(numberLabel.text ?? "1") ?? 1) + 1)"
        }
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
            presenter.addPrice(value: price)
            cell.ingredientQuantity.text = String((Int(cell.ingredientQuantity.text ?? "0") ?? 0) + 1)
        }
    }
    
    func substractButtonTapped(_ cell: IngredientCell) {
        if (!(cell.ingredientQuantity.text?.isEmpty ?? true) && cell.ingredientQuantity.text != "0") {
            if let price = cell.ingredientPrice.text {
                presenter.substractPrice(value: price)
                cell.ingredientQuantity.text = String((Int(cell.ingredientQuantity.text ?? "0") ?? 0) - 1)
            }
        }
    }
}

extension DetailViewController: DetailViewDelegate {
    
    func updatePizzaPrice(newPrice: Double) {
        addToCartButton.setTitle("Add \(String(format: "%.2f", newPrice))€", for: .normal)
    }
}
