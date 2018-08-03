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
    var maskedView = UIImageView()
    var maskedImageView = UIImageView()
    
    @IBInspectable
    var maskImage : UIImage? {
        didSet{
            maskedView.image = maskImage
            updateView()
        }
    }
    
    func updateView(){
        maskedImageView.image = image
        
        if (maskedView.image != nil){
            maskedView.frame = bounds
            maskedView.contentMode = .scaleAspectFit
            
            maskedImageView.frame = maskedView.frame
            maskedImageView.contentMode = .center
            
            maskedView.layer.mask = maskedImageView.layer
            
            addSubview(maskedView)
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
