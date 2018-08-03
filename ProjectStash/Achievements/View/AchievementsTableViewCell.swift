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
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBInspectable
    var maskImage : UIImage? {
        didSet{
            levelImageView.image = maskImage
            self.mask = levelImageView
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // setLevelImageLayout()
    }
    
    func setCell(forAchievements model: Achievements) {
        if !model.accessible{
            self.contentView.alpha = 0.5
        }
        
        self.selectionStyle = .none
        levelLabel?.text = model.level
        progressLabel?.text = String("\(model.progress) pts")
        totalLabel?.text = String("\(model.total) pts")
        let trueProgressValue = model.progress / model.total
        print("\(model.progress)")
        if trueProgressValue > 0 { progressBar.setProgress(Float(trueProgressValue), animated: true) }

        let url = URL(string: model.bgImageURL)!
        let placeholderImage = UIImage(named: "BR2049")!
        cellBackgroundImageView?.af_setImage(withURL: url, placeholderImage: placeholderImage) // Download image async
    }
    
//    func setLevelImageLayout(){
//        // Apply image masking in the cell
//        let mask = CALayer()
//
//        mask.contents =  [UIImage(named: "mask")?.cgImage] as Any
//        mask.frame = CGRect(x: 0, y: 0, width: levelImageView.frame.size.width, height: levelImageView.frame.size.height)
//        levelImageView.layer.masksToBounds = true
//        levelImageView.layer.addSublayer(mask)
//    }
    
 /*   - (void)layoutSubviews
    {
    [super layoutSubviews];
    
    mainView.clipsToBounds       = YES;
    mainView.layer.cornerRadius  = 4.0f;
    mainView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    mainView.layer.shadowOpacity = 0.2f;
    mainView.layer.shadowOffset  = CGSizeMake(0, 1.0);
    mainView.layer.shadowPath    = [[UIBezierPath bezierPathWithRoundedRect:mainView.frame cornerRadius:4.0f] CGPath];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
     

 
 */
    
}
