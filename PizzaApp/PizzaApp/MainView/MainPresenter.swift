//
//  MainPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import Foundation
import UIKit

// here we set the methods from the viewController that are needed to update the view
protocol MainViewPresenter: AnyObject {
    
}

// here we set the logic methods that the viewController needs
class MainPresenter: MainViewPresenter {
    
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
}
