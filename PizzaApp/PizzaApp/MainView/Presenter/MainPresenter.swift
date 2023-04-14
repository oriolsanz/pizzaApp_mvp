//
//  MainPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import Foundation

/**
    The MainViewDelegate protocol defines methods for updating and retrieving data for the main view.
*/
protocol MainViewDelegate: NSObjectProtocol {
    
    /**
     Called when a pizza has been added to the cart successfully.
     
     - parameter pizza: A `PizzaModel` object representing the pizza that was added to the cart.
     */
    func updateCart(with pizza: PizzaModel?)
    
    /**
     Called when a specific pizza has been retrieved successfully.
     
     - parameter pizza: A `PizzaModel` object representing the pizza that was retrieved, or `nil` if the pizza could not be found.
     */
    func getPizza(pizza: PizzaModel?)
    
    /**
     Called when data (pizzas and ingredients) has been retrieved successfully.
     
     - parameters:
        - pizzas: An array of `PizzaModel` objects representing the list of pizzas.
        - ingredients: An array of `IngredientModel` objects representing the list of ingredients.
     */
    func getData(pizzas: [PizzaModel], ingredients: [IngredientModel])
}

/**
    The MainPresenter class handles business logic for the main view.
*/
class MainPresenter {
    
    weak private var mainViewDelegate : MainViewDelegate?
    
    /**
     Sets the `MainViewDelegate` for the presenter.
     
     - parameter mainViewDelegate: An instance of `MainViewDelegate` to set as the delegate for the presenter.
     */
    func setViewDelegate(mainViewDelegate: MainViewDelegate?) {
        self.mainViewDelegate = mainViewDelegate
    }
    
    /**
     Retrieves data (pizzas and ingredients) and notifies the delegate when data has been retrieved successfully.
     */
    func getData() {
        let jsonData = Utils().getJsonData()
        mainViewDelegate?.getData(pizzas: jsonData.pizzas, ingredients: jsonData.ingredients)
    }
    
    /**
     Retrieves a specific pizza from the provided list and notifies the delegate when the pizza has been retrieved successfully.
     
     - parameters:
        - list: An array of `PizzaModel` objects representing the list of pizzas to search through.
        - name: The name of the pizza to retrieve.
     */
    func getPizza(fromList list: [PizzaModel], withName name: String) {
        for pizza in list {
            if pizza.pizzaName == name {
                mainViewDelegate?.getPizza(pizza: pizza)
                return
            }
        }
        mainViewDelegate?.getPizza(pizza: nil)
    }
    
    /**
     Retrieves a specific pizza from the provided list by name.
     
     - parameters:
        - list: An array of `PizzaModel` objects representing the list of pizzas to search through.
        - name: The name of the pizza to retrieve.
     
     - returns: A `PizzaModel` object representing the pizza that was retrieved, or `nil` if the pizza could not be found.
     */
    private func getInternalPizza(_ list: [PizzaModel], _ name: String) -> PizzaModel? {
        for pizza in list {
            if pizza.pizzaName == name {
                return pizza
            }
        }
        return nil
    }
    
    /**
     Adds a pizza to the cart and notifies the delegate when the cart has been updated successfully.
     
     - parameters:
        - list: An array of `PizzaModel` objects representing the list of pizzas to search through.
        - name: The name of the pizza to add to the cart.
     */
    func addPizzaToCart(from list: [PizzaModel], with name: String) {
        mainViewDelegate?.updateCart(with: getInternalPizza(list, name))
    }
}
