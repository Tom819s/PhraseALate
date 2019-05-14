//
//  SecondViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class PhraseSelectController: UIViewController {
    
    @IBAction func bathroomPressed(_ sender: Any) {
        stringToTrans = "Where is the toilet?"
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
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    var stringToTrans = String()
    var chosenLanguage = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.layer.cornerRadius = 5
        firstButton.layer.cornerRadius = 5
        secondButton.layer.cornerRadius = 5
        thirdButton.layer.cornerRadius = 5
        fourthButton.layer.cornerRadius = 5
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderButton = sender as! UIButton
        if senderButton.tag != 1
        {
            let thirdController = segue.destination as! TranslateResultsController
            thirdController.chosenPhrase = self.stringToTrans
            thirdController.chosenLanguageInt = chosenLanguage
            
        }
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
