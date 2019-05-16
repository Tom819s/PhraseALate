//
//  SecondViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class PhraseSelectController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var medicalButton: UIButton!
    @IBOutlet weak var lostButton: UIButton!
    var chosenLanguage = Int()
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth: CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        
    }
    
    func setupButtons(){
        
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        firstButton.layer.cornerRadius = 5
        firstButton.layer.borderWidth = borderWidth
        firstButton.layer.borderColor = borderColor
        secondButton.layer.cornerRadius = 5
        secondButton.layer.borderWidth = borderWidth
        secondButton.layer.borderColor = borderColor
        thirdButton.layer.cornerRadius = 5
        thirdButton.layer.borderWidth = borderWidth
        thirdButton.layer.borderColor = borderColor
        fourthButton.layer.cornerRadius = 5
        fourthButton.layer.borderWidth = borderWidth
        fourthButton.layer.borderColor = borderColor
        
        shopButton.layer.cornerRadius = 5
        shopButton.layer.borderWidth = borderWidth
        shopButton.layer.borderColor = borderColor
        medicalButton.layer.cornerRadius = 5
        medicalButton.layer.borderWidth = borderWidth
        medicalButton.layer.borderColor = borderColor
        lostButton.layer.cornerRadius = 5
        lostButton.layer.borderWidth = borderWidth
        lostButton.layer.borderColor = borderColor
        foodButton.layer.cornerRadius = 5
        foodButton.layer.borderWidth = borderWidth
        foodButton.layer.borderColor = borderColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderButton = sender as! UIButton
        if senderButton.tag != 1
        {
            let thirdController = segue.destination as! TranslateResultsController
            thirdController.chosenPhrase = senderButton.currentTitle!
            thirdController.chosenLanguageInt = chosenLanguage
            
        }
    }
    
    
    @IBAction func tab1Pressed(_ sender: Any) {
        firstButton.setTitle("Where is the bathroom?", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        secondButton.setTitle("I need something to drink", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        thirdButton.setTitle("I am hungry", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        fourthButton.setTitle("I have dietary restrictions", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
    }
    
    @IBAction func tab2Presed(_ sender: Any) {
        firstButton.setTitle("Do you take traveler's checks?", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        secondButton.setTitle("I have US Dollars", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        thirdButton.setTitle("I cannot afford that", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        fourthButton.setTitle("What is your best price?", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
    }
    @IBAction func tab3Pressed(_ sender: Any) {
        firstButton.setTitle("I need medical attention", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        secondButton.setTitle("I feel sick", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        thirdButton.setTitle("I hurt where I am pointing", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        fourthButton.setTitle("I need to go to the hospital", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
    }
    @IBAction func tab4Pressed(_ sender: Any) {
        firstButton.setTitle("I am lost", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        secondButton.setTitle("Where is the US consulate?", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        thirdButton.setTitle("I cannot find my passport", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        fourthButton.setTitle("Do you know someone who speaks English?", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
