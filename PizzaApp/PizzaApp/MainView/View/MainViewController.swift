//
//  MainViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cartCounterLabel: UILabel!
    
    private let presenter = MainPresenter()
    
    var pizzaArray: [PizzaModel] = []
    var pizzaCart: [PizzaModel] = []
    var pizzaModel: PizzaModel?
    var ingredientsData: [IngredientModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(mainViewDelegate: self)
        getData()
        configTableView()
        configStrings()
    }
    
    func configStrings() {
        
        titleLabel.text = "Pizza App"
        cartCounterLabel.text = "\(pizzaCart.count)"
    }
    
    func configTableView() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName: "PizzaCell", bundle: nil), forCellReuseIdentifier: "PizzaCell")
    }
    
    func getData() {
        presenter.getData()
    }
    
    func returnPizzaModel(pizza: PizzaModel?) -> PizzaModel? {
        return pizzaModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfirmSegue" {
            if let destinationVC = segue.destination as? ConfirmViewController {
                destinationVC.pizzasInCart = pizzaCart
                destinationVC.pizzaIngredients = ingredientsData
            }
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showConfirmSegue", sender: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = pizzaArray[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        (cell as? PizzaCell)?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
}

extension MainViewController: PizzaCellDelegate {
    
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
    
    func addToCartButtonTapped(_ cell: PizzaCell) {
        
        if let name = cell.pizzaName.text {
            presenter.addPizzaToCart(from: pizzaArray, with: name)
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    func getData(pizzas: [PizzaModel], ingredients: [IngredientModel]) {
        pizzaArray = pizzas
        ingredientsData = ingredients
    }
    
    func getPizza(pizza: PizzaModel?) {
        pizzaModel = pizza
    }
    
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
    
    func buyPizza(pizzas: [PizzaModel?]) {
        for pizza in pizzas {
            var p = pizza
            p?.finalView = true
            updateCart(with: p)
        }
    }
}
