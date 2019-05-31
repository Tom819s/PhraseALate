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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        setToTheme()
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
            textEnter.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textEnter.text == "")
        {
            textEnter.text = "Please Enter What You Want To Translate"
            textEnter.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
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
            resultsController.chosenLanguageInt = self.chosenLanguage
        }
        
    }
    
    
    func setToTheme(){
        
        menuButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        menuButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        menuButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        translateButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        translateButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        translateButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        textEnter.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        textEnter.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        
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
