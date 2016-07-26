//
//  CategoryFlavorCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class CategoryFlavorCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.layer.cornerRadius = textLabel.frame.size.height / 3
        textLabel.layer.borderWidth = 1.0
        textLabel.layer.borderColor = UIColor.orangeColor().CGColor
        textLabel.layer.masksToBounds = true
    }
    
    func configureCell(text: String?, isSelected: Bool) {
        textLabel.text = text
        textLabel.backgroundColor = isSelected ? UIColor.orangeColor() : UIColor.clearColor()
        selected = isSelected
    }
}
