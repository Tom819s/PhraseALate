//
//  SecondViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBAction func bathroomPressed(_ sender: Any) {
        stringToTrans = "Where is the bathroom?"
    }
    @IBAction func checksPressed(_ sender: Any) {
        
        stringToTrans = "Do You Take Traveler's Checks?"
    }
    @IBAction func lostPressed(_ sender: Any) {
        stringToTrans = "I Am Lost"
    }
    @IBAction func medicalPressed(_ sender: Any) {
        stringToTrans = "I Need Medical Attention"
    }
    
    
    var stringToTrans = String()
    var chosenLanguage = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let thirdController = segue.destination as! ThirdViewController
        
        thirdController.chosenPhrase = self.stringToTrans
        thirdController.chosenLanguageInt = chosenLanguage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
