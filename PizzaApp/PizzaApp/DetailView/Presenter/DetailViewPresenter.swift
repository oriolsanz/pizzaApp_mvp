//
//  DetailViewPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 12/4/23.
//

import Foundation

// here we set the methods from the viewController that are needed to update the view
protocol DetailViewDelegate: NSObjectProtocol {
    func updatePizzaPrice(newPrice: Double)
    func updatePizzaNumber(newValue: Int)
    func getPizzaList(pizzaList: [PizzaModel?])
    func getIngredientList(ingredientList: [IngredientModel])
}

// here we set the logic methods that the viewController needs
class DetailPresenter {
    
    var pizzaPrice = 0.0
    var pizzasNumber = 1
    var pizzaBaseIngredients: [String: Int] = [:]
    var finalPizza: PizzaModel?
    var pizzasToBuy: [PizzaModel?] = []
    
    weak private var detailViewDelegate : DetailViewDelegate?

    func setViewDelegate(detailViewDelegate: DetailViewDelegate?) {
        self.detailViewDelegate = detailViewDelegate
    }
    
    func setPizza(_ pizza: PizzaModel) {
        finalPizza = pizza
    }
    
    func getPizzas() {
        pizzasToBuy = []
        for _ in 0 ..< pizzasNumber {
            var pizzaToAppend = finalPizza
            pizzaToAppend?.pizzaPrice = Decimal(floatLiteral: pizzaPrice).doubleValue
            pizzasToBuy.append(pizzaToAppend)
        }
        detailViewDelegate?.getPizzaList(pizzaList: pizzasToBuy)
    }
    
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
    
    func addPizza() {
        pizzasNumber += 1
        detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
        detailViewDelegate?.updatePizzaNumber(newValue: pizzasNumber)
    }
    
    func substractPizza() {
        if pizzasNumber != 1 {
            pizzasNumber -= 1
            detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice*Double(pizzasNumber))
            detailViewDelegate?.updatePizzaNumber(newValue: pizzasNumber)
        }
    }
    
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
