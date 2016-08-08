//
//  NewRecipeSteps_StepCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/28.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeSteps_StepCell: UITableViewCell {
    @IBOutlet weak var stepIDLabel: UILabel!
    @IBOutlet weak var stepDetailLabel: UILabel!
    @IBOutlet weak var stepImageView: UIImageView!

    func configureCell(step: Step) {
        stepIDLabel.text = "STEP \(step.stepID!)"
        stepDetailLabel.text = step.detail
        if let imageData = step.image {
            stepImageView.image = UIImage(data: imageData)
            stepImageView.hidden = false
        } else {
            stepImageView.image = nil
            stepImageView.hidden = true
        }
        
        layoutIfNeeded()
    }
}
