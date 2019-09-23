//
//  DetailViewController.swift
//  Periodic Table
//
//  Created by Nhan Cao on 9/18/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var elementNameLabel: UILabel!
    @IBOutlet weak var elementSymbolView: ElementGridView!
    
    var elementDetails: [String: Any]? = [String: Any]() {
        didSet {
            refreshUI()
        }
    }
    
    private func refreshUI() {
        self.loadViewIfNeeded()
        
        if let details = elementDetails {
            elementNameLabel.text = (details["name"] as? String) ?? "N/A"
            elementSymbolView.display(symbol: details["symbol"] as? String, number: details["number"] as? Int)
        } else {
            elementNameLabel.text = "Periodic Table"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUI()
    }
    

}

extension DetailViewController: ElementSelectionDelegate {
    func elementSelected(_ element: [String : Any]) {
        elementDetails = element
    }
}
