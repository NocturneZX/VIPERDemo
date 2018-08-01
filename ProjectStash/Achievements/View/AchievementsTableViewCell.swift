//
//  AchievementsTableViewCell.swift
//  ProjectStash
//
//  Created by Julio Reyes on 7/30/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import UIKit
import AlamofireImage

class AchievementsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(forAchievements model: Achievements) {
        if !model.accessible{
            self.alpha = 0.5
            self.setSelected(false, animated: false)
        }
        
        self.selectionStyle = .none
        levelLabel?.text = model.level
        progressLabel?.text = String("\(model.progress)pts")
        totalLabel?.text = String("\(model.total)pts")
        let trueProgressValue = model.progress / model.total
        progressBar.setProgress(Float(trueProgressValue), animated: true)

        let url = URL(string: model.bgImageURL)!
        let placeholderImage = UIImage(named: "placeholder")!
        cellBackgroundImageView?.af_setImage(withURL: url, placeholderImage: placeholderImage) // Download image async
    }
}
