//
//  NewRecipeSummary_ForPersonCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeSummary_ForPersonCell: UITableViewCell {
    @IBOutlet weak var forPersonLabel: UILabel!
    @IBOutlet weak var forPersonStepper: UIStepper!
    
    var newRecipe: Recipe?
    
    func configureCell(recipe: Recipe) {
        newRecipe = recipe
        
        forPersonStepper.value = (recipe.forPersons?.doubleValue)!
        let numOfPerson = Int(forPersonStepper.value)
        forPersonLabel.text = "For \(numOfPerson) " + ((numOfPerson > 1) ? "Persons" : "Person")
    }
    
    @IBAction func forPersonStepperValueChanged(sender: AnyObject) {
        let numOfPerson = Int(forPersonStepper.value)
        forPersonLabel.text = "For \(numOfPerson) " + ((numOfPerson > 1) ? "Persons" : "Person")
        newRecipe?.forPersons = NSNumber(integer: numOfPerson)
    }
    
}
