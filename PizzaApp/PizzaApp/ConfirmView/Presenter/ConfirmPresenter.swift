//
//  ConfirmPresenter.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 13/4/23.
//

import Foundation

protocol ConfirmViewDelegate: NSObjectProtocol {
    func getCartAmount(_ amount: Double)
}

class ConfirmPresenter {
    
    weak private var confirmViewDelegate: ConfirmViewDelegate?
    
    func setViewDelegate(confirmViewDelegate: ConfirmViewDelegate?) {
        self.confirmViewDelegate = confirmViewDelegate
    }
    
    func calculateCartAmount(pizzaArray: [PizzaModel?]) {
        var amount = 0.0
        for pizza in pizzaArray {
            amount += pizza?.pizzaPrice ?? 0.0
        }
        confirmViewDelegate?.getCartAmount(amount)
    }
}
