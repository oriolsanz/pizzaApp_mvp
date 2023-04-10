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
    
    var pizzaImage: UIImageView?
    var pizzaName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.titleLabel?.text = "<"
        pizzaNameLabel.text = pizzaName
        pizzaImageView.image = pizzaImage?.image
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
