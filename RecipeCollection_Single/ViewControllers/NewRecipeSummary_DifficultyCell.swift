//
//  NewRecipeSummary_DifficultyCell.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/14/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class NewRecipeSummary_DifficultyCell: UITableViewCell {
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyStarStack: UIStackView!
    
    var difficulties: [Difficulty]?
    var newRecipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let starSize = frame.size.width / 25
        for starButton in difficultyStarStack.arrangedSubviews {
            starButton.heightAnchor.constraintEqualToConstant(starSize).active = true
            starButton.widthAnchor.constraintEqualToConstant(starSize).active = true
        }
    }
    
    func configureCell(recipe: Recipe, difficultyArray: [Difficulty]) {
        newRecipe = recipe
        difficulties = difficultyArray
        
        if let difficulty = recipe.difficulty {
            difficultyLabel.text = difficulty.name
            for subview in difficultyStarStack.subviews {
                if let starButton = subview as? UIButton {
                    starButton.selected = (starButton.tag <= difficulty.level?.integerValue)
                }
            }
        }
    }

    @IBAction func difficultyStarButtonOnClicked(sender: AnyObject) {
        let buttonIndex = sender.tag
        for subview in difficultyStarStack.subviews {
            if let starButton = subview as? UIButton {
                starButton.selected = (starButton.tag <= buttonIndex)
            }
        }
        
        for difficulty in difficulties! {
            if difficulty.level?.integerValue == buttonIndex {
                newRecipe?.difficulty = difficulty
                difficultyLabel.text = difficulty.name
                break
            }
        }
    }

}
