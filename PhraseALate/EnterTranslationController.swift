//
//  FourthViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/31/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class EnterTranslationController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textEnter: UITextView!
    
    var stringToTrans = String()
    var chosenLanguage = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textEnter.delegate = self
        textEnter.text = "Please Enter What You Want To Translate"
        textEnter.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textEnter.textColor == UIColor.lightGray)
        {
            textEnter.text = ""
            textEnter.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textEnter.text == "")
        {
            textEnter.text = "Please Enter What You Want To Translate"
            textEnter.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func translatePressed(_ sender: Any) {
        
        self.stringToTrans = textEnter.text.replacingOccurrences(of: "\n", with: "%20")
        self.performSegue(withIdentifier: "toResults", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(sender is UIButton)
        {
            let resultsController = segue.destination as! TranslateResultsController
            let parsedString = stringToTrans.replacingOccurrences(of: "[!@#$%^&*()<>;:{}]", with: " ", options: [.regularExpression, .caseInsensitive])
            resultsController.chosenPhrase = parsedString
            print(resultsController.chosenPhrase)
            resultsController.chosenLanguageInt = self.chosenLanguage
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
