//
//  ConfirmPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import Foundation

/**
 A protocol implemented by the ConfirmViewController to receive the calculated cart amount from the presenter.
*/
protocol ConfirmViewDelegate: NSObjectProtocol {
    func getCartAmount(_ amount: Double)
}

/**
 A presenter class that calculates the cart amount based on the list of pizzas received, and then calls the `getCartAmount` method of the delegate to pass the result back to the view controller.
*/
class ConfirmPresenter {
    
    weak private var confirmViewDelegate: ConfirmViewDelegate?
    
    /**
     Sets the view delegate to the passed parameter.
     
     - Parameter confirmViewDelegate: An instance of ConfirmViewDelegate
     */
    func setViewDelegate(confirmViewDelegate: ConfirmViewDelegate?) {
        self.confirmViewDelegate = confirmViewDelegate
    }
    
    /**
     Calculates the cart amount based on the list of pizzas received, and then calls the `getCartAmount` method of the delegate to pass the result back to the view controller.
     
     - Parameter pizzaArray: An array of PizzaModel objects
     */
    func calculateCartAmount(pizzaArray: [PizzaModel?]) {
        var amount = 0.0
        for pizza in pizzaArray {
            amount += pizza?.pizzaPrice ?? 0.0
        }
        confirmViewDelegate?.getCartAmount(amount)
    }
}
