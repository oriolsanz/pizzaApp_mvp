//
//  DetailViewPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 12/4/23.
//

import Foundation

/**
 The `DetailViewDelegate` protocol defines methods that a delegate of the detail view controller can implement to respond to events in the view controller.
 */
protocol DetailViewDelegate: NSObjectProtocol {
    
    /**
     Called when the price of the pizza changes.
     
     - Parameter newPrice: The new price of the pizza.
     */
    func updatePizzaPrice(newPrice: Double)
    
    /**
     Called when the number of pizzas changes.
     
     - Parameter newValue: The new number of pizzas.
     */
    func updatePizzaNumber(newValue: Int)
    
    /**
     Called when a list of pizzas is obtained.
     
     - Parameter pizzaList: An array of optional `PizzaModel` objects.
     */
    func getPizzaList(pizzaList: [PizzaModel?])
    
    /**
     Called when a list of ingredients is obtained.
     
     - Parameter ingredientList: An array of `IngredientModel` objects.
     */
    func getIngredientList(ingredientList: [IngredientModel])
}

/**
A presenter class for the Detail View. This class is responsible for updating the pizza price and number, getting the pizza and ingredient list, and manipulating the pizza and ingredient quantity.
 */
class DetailPresenter {
    
    /// The current pizza price
    var pizzaPrice = 0.0

    /// The number of pizzas to buy
    var pizzasNumber = 1

    /// The base ingredients for the pizza
    var pizzaBaseIngredients: [String: Int] = [:]

    /// The final pizza to buy
    var finalPizza: PizzaModel?

    /// The list of pizzas to buy
    var pizzasToBuy: [PizzaModel?] = []

    /// The Detail View delegate
    weak private var detailViewDelegate : DetailViewDelegate?

    /**
     Sets the Detail View delegate.
     
     - Parameter detailViewDelegate: The delegate to set.
     */
    func setViewDelegate(detailViewDelegate: DetailViewDelegate?) {
        self.detailViewDelegate = detailViewDelegate
    }
    
    /**
     Sets the final pizza to buy.
     
     - Parameter pizza: The pizza to set.
     */
    func setPizza(_ pizza: PizzaModel) {
        finalPizza = pizza
    }

    /**
     Gets the list of pizzas to buy.
     */
    func getPizzas() {
        pizzasToBuy = []
        for _ in 0 ..< pizzasNumber {
            var pizzaToAppend = finalPizza
            pizzaToAppend?.pizzaPrice = Decimal(floatLiteral: pizzaPrice).doubleValue
            pizzasToBuy.append(pizzaToAppend)
        }
        detailViewDelegate?.getPizzaList(pizzaList: pizzasToBuy)
    }

    /**
     Adds the price of an ingredient to the pizza price and updates the ingredient quantity.

     - Parameters:
        - value: The price of the ingredient to add.
        - toIngredient: The name of the ingredient to update.
        - fromIngredientsList: The list of ingredients to update.
     */
    func addPrice(value: String, toIngredient: String, fromIngredientsList: [IngredientModel]) {
        var newList = fromIngredientsList
        var removedEuroSymbol = value
        if value.last == "€" {
            removedEuroSymbol = String(value.dropLast(1))
        }
        pizzaPrice += Double(removedEuroSymbol) ?? 0.0
        detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
        for i in 0 ..< fromIngredientsList.count {
            if fromIngredientsList[i].ingredientName == toIngredient {
                finalPizza?.pizzaIngredients.append(fromIngredientsList[i].ingredientID)
                newList[i].ingredientQuantity += 1
                detailViewDelegate?.getIngredientList(ingredientList: newList)
            }
        }
        detailViewDelegate?.getIngredientList(ingredientList: newList)
    }

    /**
     Subtracts the price of an ingredient from the pizza price and updates the ingredient quantity.
     
     - Parameters:
        - value: The price of the ingredient to subtract.
        - toIngredient: The name of the ingredient to update.
        - fromIngredientsList: The list of ingredients to update.
     */
    func substractPrice(value: String, toIngredient: String, fromIngredientsList: [IngredientModel]) {
        var newList = fromIngredientsList
        var removedEuroSymbol = value
        if value.last == "€" {
            removedEuroSymbol = String(value.dropLast(1))
        }
        for i in 0 ..< fromIngredientsList.count {
            if fromIngredientsList[i].ingredientName == toIngredient {
                if newList[i].ingredientQuantity != 0 && pizzaBaseIngredients["\(toIngredient)"] != fromIngredientsList[i].ingredientQuantity {
                    pizzaPrice -= Double(removedEuroSymbol) ?? 0.0
                    detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
                    for j in 0 ..< (finalPizza?.pizzaIngredients.count ?? 0) {
                        if finalPizza?.pizzaIngredients[j] == fromIngredientsList[i].ingredientID {
                            finalPizza?.pizzaIngredients.remove(at: j)
                            break
                        }
                    }
                    newList[i].ingredientQuantity -= 1
                }
                detailViewDelegate?.getIngredientList(ingredientList: newList)
            }
        }
        detailViewDelegate?.getIngredientList(ingredientList: newList)
    }
    
    /**
     Adds one pizza to the current order, updates the pizza price and number of pizzas displayed in the view.
     */
    func addPizza() {
        pizzasNumber += 1
        detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
        detailViewDelegate?.updatePizzaNumber(newValue: pizzasNumber)
    }
    
    /**
     Subtracts one pizza from the current order, updates the pizza price and number of pizzas displayed in the view. If there is only one pizza in the order, nothing happens.
     */
    func substractPizza() {
        if pizzasNumber != 1 {
            pizzasNumber -= 1
            detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
            detailViewDelegate?.updatePizzaNumber(newValue: pizzasNumber)
        }
    }
    
    /**
     Updates the ingredient list by incrementing the quantity of each ingredient used in the given pizza.
     Updates the pizza base ingredients dictionary with the new quantity for each ingredient.
     
     - Parameters:
        - fromPizza: The pizza whose ingredients will be added to the list.
        - withIngredients: The list of ingredients to be updated.
     */
    func getPizzaIngredients(fromPizza: PizzaModel, withIngredients: [IngredientModel]) {
        var newList = withIngredients
        for ingredientID in fromPizza.pizzaIngredients {
            for i in 0 ..< newList.count {
                if newList[i].ingredientID == ingredientID {
                    newList[i].ingredientQuantity += 1
                    pizzaBaseIngredients[newList[i].ingredientName] = newList[i].ingredientQuantity
                }
            }
        }
        detailViewDelegate?.getIngredientList(ingredientList: newList)
    }
}
