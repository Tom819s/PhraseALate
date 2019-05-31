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
    var textColor = UIColor.darkGray.cgColor
    var buttonColor = UIColor.darkGray.cgColor
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        
        self.borderColor     = UserDefaults.standard.object(forKey: "Border Color") as! CGColor? ?? UIColor.gray.cgColor
        self.buttonColor     = UserDefaults.standard.object(forKey: "Button Color") as! CGColor? ?? UIColor.blue.cgColor
        self.textColor       = UserDefaults.standard.object(forKey: "Text Color") as! CGColor? ?? UIColor.white.cgColor
        layer.cornerRadius   = 5
        layer.borderWidth    = borderWidth
    }
}
