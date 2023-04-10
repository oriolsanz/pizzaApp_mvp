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
    
    private let presenter = MainPresenter()
    
    var pizzaArray: [PizzaCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPizzas()
        configTableView()
        configStrings()
    }
    
    func configStrings() {
        
        titleLabel.text = "Pizza App"
    }
    
    func configTableView() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName: "PizzaCell", bundle: nil), forCellReuseIdentifier: "PizzaCell")
    }
    
    func getPizzas() {
        
        pizzaArray.append(PizzaCellModel(pizzaImage: "DICAPRAAAAA", pizzaName: "Di Capra"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PM4E", pizzaName: "4 Estaciones"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PM4Q", pizzaName: "4 Quesos"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMBQM", pizzaName: "Barbacoa"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMCA", pizzaName: "Carbonara"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMFU", pizzaName: "Funghi"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMHO", pizzaName: "Hawaiana"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMMA", pizzaName: "Margarita"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMME", pizzaName: "Mediterránea"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMPE", pizzaName: "Pepperoni"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMPR", pizzaName: "Prosciutto"))
        pizzaArray.append(PizzaCellModel(pizzaImage: "PMVE", pizzaName: "Vegetariana"))
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
        vc.pizzaName = cell.pizzaName.text
        vc.pizzaImage = cell.pizzaImage
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
}
