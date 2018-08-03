//
//  UIImageViewWithMask.swift
//  ProjectStash
//
//  Created by Julio Reyes on 8/3/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewWithMask: UIImageView {
    var maskedImageView = UIImageView()
    
    @IBInspectable
    var maskImage : UIImage? {
        didSet{
            maskedImageView.image = maskImage
            maskedImageView.frame = bounds
            self.mask = maskedImageView
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
