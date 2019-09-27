//
//  CustomeTableViewCell.swift
//  Periodic Table
//
//  Created by Nhan Cao on 9/19/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit

class CustomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var previewView: ElementGridView!
    @IBOutlet weak var elementNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .black
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        previewView.isSelected = selected
        
        if selected {
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            elementNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elementNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

}
