//
//  NewRecipeSummary_SummaryCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeSummary_SummaryCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var newRecipe: Recipe?

    func configureCell(recipe: Recipe) {
        newRecipe = recipe
        recipeNameTextField.text = recipe.name
        subtitleTextField.text = recipe.subtitle
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text! as NSString
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case recipeNameTextField:
            newRecipe?.name = newString
        case subtitleTextField:
            newRecipe?.subtitle = newString
        default:
            break
        }
        return true
    }
}
