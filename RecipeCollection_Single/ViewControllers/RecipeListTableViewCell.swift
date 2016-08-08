//
//  RecipeListTableViewCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/4.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class RecipeListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!

    func configureCell(recipe: Recipe) {
        titleLabel.text = recipe.name
        subtitleLabel.text = recipe.subtitle
        if let coverImageData = recipe.cover, let coverImage = UIImage(data: coverImageData) {
            coverImageView.image = coverImage
        } else {
            coverImageView.image = nil
        }
    }

}
