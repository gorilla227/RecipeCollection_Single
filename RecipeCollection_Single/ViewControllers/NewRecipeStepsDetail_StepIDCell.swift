//
//  NewRecipeStepsDetail_StepIDCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/30.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeStepsDetail_StepIDCell: UITableViewCell {
    @IBOutlet weak var stepIDLabel: UILabel!
    @IBOutlet weak var stepIDStepper: UIStepper!
    
    func configureCell(step: [String: AnyObject], maximum: Int) {
        stepIDStepper.value = (step[Step.Keys.StepID] as! NSNumber).doubleValue
        stepIDStepper.maximumValue = Double(maximum)
        stepIDLabel.text = "Step: \(Int(stepIDStepper.value))"
    }

    @IBAction func stepperValueChanged(sender: AnyObject) {
        stepIDLabel.text = "Step: \(Int(stepIDStepper.value))"
    }
}
