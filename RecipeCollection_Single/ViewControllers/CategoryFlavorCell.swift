//
//  CategoryFlavorCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

protocol DeleteCategoryFlavorDelegate {
    func DeleteCategoryFlavor(indexPath: NSIndexPath)
}

class CategoryFlavorCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var indexPath: NSIndexPath?
    var delegate: DeleteCategoryFlavorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.layer.cornerRadius = textLabel.frame.size.height / 3
        textLabel.layer.borderWidth = 1.0
        textLabel.layer.borderColor = UIColor.orangeColor().CGColor
        textLabel.layer.masksToBounds = true
        
        let deleteButtonSize = textLabel.bounds.size.height
        deleteButton.widthAnchor.constraintEqualToConstant(deleteButtonSize).active = true
        deleteButton.heightAnchor.constraintEqualToConstant(deleteButtonSize).active = true
    }
    
    func configureCell(text: String?, indexPath: NSIndexPath, isSelected: Bool, isEditing: Bool, delegate: DeleteCategoryFlavorDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        textLabel.text = text
        textLabel.backgroundColor = isSelected ? UIColor.orangeColor() : UIColor.clearColor()
        selected = isSelected
        
        deleteButton.hidden = !isEditing
    }
    
    @IBAction func deleteButtonOnClicked(sender: AnyObject) {
        if let delegate = delegate, let indexPath = indexPath {
            delegate.DeleteCategoryFlavor(indexPath)
        }
    }
}
