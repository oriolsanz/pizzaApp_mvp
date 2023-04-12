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
}

// here we set the logic methods that the viewController needs
class DetailPresenter {
    
    var pizzaPrice = 0.0
    
    weak private var detailViewDelegate : DetailViewDelegate?

    func setViewDelegate(detailViewDelegate: DetailViewDelegate?) {
        self.detailViewDelegate = detailViewDelegate
    }
    
    func addPrice(value: String) {
        var removedEuroSymbol = value
        if value.last == "€" {
            removedEuroSymbol = String(value.dropLast(1))
        }
        pizzaPrice += Double(removedEuroSymbol) ?? 0.0
        detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice)
    }
    
    func substractPrice(value: String) {
        var removedEuroSymbol = value
        if value.last == "€" {
            removedEuroSymbol = String(value.dropLast(1))
        }
        pizzaPrice -= Double(removedEuroSymbol) ?? 0.0
        detailViewDelegate?.updatePizzaPrice(newPrice: pizzaPrice)
    }
}
