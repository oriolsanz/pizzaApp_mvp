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
        
        pizzaArray = presenter.getData().pizzas
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        // TODO go to new view
        print("pizzas: \(pizzaCart)")
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
        vc.pizza = presenter.getPizza(fromList: pizzaArray, withName: cell.pizzaName.text ?? "")
        vc.ingredientsList = presenter.getData().ingredients
        
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
    
    func updateCart(with pizza: PizzaModel?) {
        if let pizza = pizza {
            pizzaCart.append(pizza)
        }
        cartCounterLabel.text = "\(pizzaCart.count)"
    }
}

extension MainViewController: DetailViewControllerDelegate {
    
    func buyPizza(pizzas: [PizzaModel?]) {
        for pizza in pizzas {
            updateCart(with: pizza)
        }
    }
}
