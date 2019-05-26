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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderButton = sender as! UIButton
        if senderButton.tag != 1
        {
            playSound()
            let thirdController = segue.destination as! TranslateResultsController
            thirdController.chosenPhrase = senderButton.currentTitle!
            thirdController.chosenLanguageInt = chosenLanguage
            
        }
    }
    
    
    @IBAction func tab1Pressed(_ sender: Any) {
        playSound()
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
        playSound()
        firstButton.setTitle("Do you take traveler's checks?", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        secondButton.setTitle("I have US Dollars", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        thirdButton.setTitle("I cannot afford that", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        fourthButton.setTitle("What is your best price?", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
    }
    @IBAction func tab3Pressed(_ sender: Any) {
        playSound()
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
        playSound()
        firstButton.setTitle("I am lost", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        secondButton.setTitle("Where is the US consulate?", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        thirdButton.setTitle("I cannot find my passport", for: .normal)
        thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        fourthButton.setTitle("Do you know someone who speaks English?", for: .normal)
        fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    @IBAction func menuPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
