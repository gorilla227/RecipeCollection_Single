//
//  NewRecipeSummary_CookingTimeCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/18.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeSummary_CookingTimeCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var cookingTimeTextField: UITextField!

    var newRecipe: Recipe?
    
    func configureCell(recipe: Recipe) {
        newRecipe = recipe
        cookingTimeTextField.text = recipe.cookingTime
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text! as NSString
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
        
        newRecipe?.cookingTime = newString
        return true
    }

}
