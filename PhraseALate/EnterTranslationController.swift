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
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    
    var stringToTrans = String()
    var chosenLanguage = Int()
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth : CGFloat = 2.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateButton.layer.cornerRadius = 5
        translateButton.layer.borderWidth = borderWidth
        translateButton.layer.borderColor = borderColor
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        textEnter.delegate = self
        textEnter.text = "Please Enter What You Want To Translate"
        textEnter.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textEnter.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textEnter.textColor == UIColor.lightGray)
        {
            textEnter.text = ""
            textEnter.textColor = UIColor.init(red: 0.294, green: 0.463, blue: 0.918, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textEnter.text == "")
        {
            textEnter.text = "Please Enter What You Want To Translate"
            textEnter.textColor = UIColor.white
        }
        
    }
    
    @IBAction func translatePressed(_ sender: Any) {
        playSound()
        
        self.stringToTrans = textEnter.text.replacingOccurrences(of: "\n", with: "%20")
        self.performSegue(withIdentifier: "toResults", sender: nil)
    }
    
    
    @IBAction func menuPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
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
