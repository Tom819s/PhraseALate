//
//  ViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class TitlePageController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phrasesButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    
    var phraseChose = false
    var transChose = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pickController = segue.destination as! LanguagePickerController
        
        pickController.isPhrase = phraseChose
        pickController.isTranslate = transChose
    }
    
    
    @IBAction func phrasePressed(_ sender: Any) {        phraseChose = true
        transChose = false
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    
    @IBAction func transPressed(_ sender: Any) {
        phraseChose = false
        transChose = true
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
}

