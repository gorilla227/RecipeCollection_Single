//
//  NewRecipeStepsDetail_StepDescriptionCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/30.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeStepsDetail_StepDescriptionCell: UITableViewCell {
    @IBOutlet weak var stepDescriptionTextView: UITextViewWithPlaceHolder!

    func configureCell(step: [String: AnyObject]) {
        stepDescriptionTextView.text = step[Step.Keys.Detail] as? String
    }
}
