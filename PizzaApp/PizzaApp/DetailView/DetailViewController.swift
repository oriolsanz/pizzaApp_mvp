//
//  DetailViewController.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pizzaNameLabel: UILabel!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    var pizzaImage: UIImageView?
    var pizzaName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    
    func configView() {
        
        backButton.titleLabel?.text = "< Back"
        pizzaNameLabel.text = pizzaName
        pizzaImageView.image = pizzaImage?.image
        ingredients.text = "Ingredientes:"
        addToCartButton.titleLabel?.text = "Add $100"
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}