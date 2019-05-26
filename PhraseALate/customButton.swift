//
//  customButton.swift
//  PhraseALate
//
//  Created by Thomas Martin on 5/26/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class customButton : UIButton{

    var borderWidth : CGFloat = 2.0
    var borderColor = UIColor.darkGray.cgColor
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        layer.cornerRadius = 5
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
}
