//
//  MainPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import Foundation

// here we set the methods from the viewController that are needed to update the view
protocol MainViewDelegate: NSObjectProtocol {
    func updateCart(with pizza: PizzaModel?)
}

// here we set the logic methods that the viewController needs
class MainPresenter {
    
    weak private var mainViewDelegate : MainViewDelegate?
    
    func setViewDelegate(mainViewDelegate: MainViewDelegate?) {
        self.mainViewDelegate = mainViewDelegate
    }
    
    func getData() -> (pizzas: [PizzaModel], ingredients: [IngredientModel]) {
        return Utils().getJsonData()
    }
    
    func getPizza(fromList list: [PizzaModel], withName name: String) -> PizzaModel? {
        for pizza in list {
            if pizza.pizzaName == name {
                return pizza
            }
        }
        return nil
    }
    
    func addPizzaToCart(from list: [PizzaModel], with name: String) {
        mainViewDelegate?.updateCart(with: getPizza(fromList: list, withName: name))
    }
}
