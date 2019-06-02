//
//  currencyCell.swift
//  PhraseALate
//
//  Created by Thomas Martin on 6/2/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class currencyCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    func setCountry(countryString: String )
    {
        let countryCodeString = String(countryString.prefix(2))
        currencyLabel.text = " " + getFlags(countryCode: countryCodeString) + countryString
    }
}
