//
//  SettingsViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 5/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var menuButtons: customButton!
    @IBOutlet weak var purpleButton: customButton!
    @IBOutlet weak var classicButton: customButton!
    @IBOutlet weak var darkModeButton: customButton!
    @IBOutlet weak var papyrusButton: customButton!
    
    
    struct globalValues {
        
      static var newBorderColor : CGColor           = UIColor.darkGray.cgColor
      static var newButtonColor : CGColor           = UIColor.blue.cgColor
      static var newBackgroundColor : CGColor       = UIColor.blue.cgColor
      static var newTextColor : CGColor             = UIColor.white.cgColor
        
        static var colorDict : [String? :CGColor] = [:]
    }
    
    var backgroundString : String           = String()
    var textString : String                 = String()
    var borderString : String               = String()
    var buttonString : String               = String()
    

    @IBAction func menuButtonPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToTheme()
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func classicPressed(_ sender: Any) {
        
        
        globalValues.newBorderColor     =       UIColor.darkGray.cgColor
        globalValues.newButtonColor     =       UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 1.0).cgColor
        globalValues.newBackgroundColor =       UIColor.init(red: 0.885, green: 0.934, blue: 1.000, alpha: 1.0).cgColor
        globalValues.newTextColor       =       UIColor.white.cgColor
        
        backgroundString    = "lightblue"
        textString          = "white"
        borderString        = "darkgray"
        buttonString        = "darkblue"
        
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        
        setToTheme()
        storeSettings()
        
    }
    
    @IBAction func purplePressed(_ sender: Any) {
        
        let lightPurple = UIColor.init(red: 0.557, green: 0.220, blue: 0.576, alpha: 1.0).cgColor
        
        globalValues.newBorderColor     =       UIColor.white.cgColor
        globalValues.newButtonColor     =       UIColor.purple.cgColor
        globalValues.newBackgroundColor =       lightPurple
        globalValues.newTextColor       =       UIColor.white.cgColor
        
        backgroundString    = "lightpurple"
        textString          = "white"
        borderString        = "white"
        buttonString        = "purple"
        
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        
        
        setToTheme()
        storeSettings()
    }
    
    @IBAction func darkPressed(_ sender: Any) {
        globalValues.newBorderColor     =       UIColor.lightGray.cgColor
        globalValues.newButtonColor     =       UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha:    1.0).cgColor
        globalValues.newBackgroundColor =       UIColor.init(red: 0.100, green: 0.100, blue: 0.100,     alpha: 1.0).cgColor
        globalValues.newTextColor       =       UIColor.white.cgColor
        
        backgroundString    = "darkbackground"
        textString          = "white"
        borderString        = "lightgray"
        buttonString        = "black"
        
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        setToTheme()
        storeSettings()
    }
    
    @IBAction func papyrusPressed(_ sender: Any) {
        globalValues.newBorderColor     =       UIColor.lightGray.cgColor
        globalValues.newButtonColor     =       UIColor.init(red: 0.394, green: 0.253, blue: 0.000,          alpha: 1.0).cgColor
        globalValues.newBackgroundColor =       UIColor.init(red: 0.672, green: 0.637, blue: 0.568,          alpha: 1.0).cgColor
        globalValues.newTextColor       =       UIColor.white.cgColor
        
        backgroundString    = "lightbrown"
        textString          = "white"
        borderString        = "lightgray"
        buttonString        = "brown"
        
        
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        setToTheme()
        storeSettings()
        
    }
    
    
    
    func storeSettings(){
        UserDefaults.standard.set(backgroundString,    forKey: "Background Color")
        UserDefaults.standard.set(textString      ,    forKey: "Text Color")
        UserDefaults.standard.set(borderString    ,    forKey: "Border Color")
        UserDefaults.standard.set(buttonString    ,    forKey: "Button Color")
    }

    func setToTheme(){
        
        menuButtons.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        menuButtons.layer.backgroundColor =  SettingsViewController.globalValues.newButtonColor
        menuButtons.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        purpleButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        purpleButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        purpleButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        classicButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        classicButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        classicButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        darkModeButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        darkModeButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        darkModeButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        papyrusButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        papyrusButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        papyrusButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
    }
}



func loadSettings()
{
   SettingsViewController.globalValues.newBorderColor     = SettingsViewController.globalValues.colorDict[UserDefaults.standard.string(forKey: "Border Color")] ?? UIColor.lightGray.cgColor
    print(SettingsViewController.globalValues.newBorderColor)
    
   SettingsViewController.globalValues.newButtonColor     =  SettingsViewController.globalValues.colorDict[UserDefaults.standard.string(forKey: "Button Color")] ?? UIColor.blue.cgColor
    
   SettingsViewController.globalValues.newBackgroundColor =   SettingsViewController.globalValues.colorDict[UserDefaults.standard.string(forKey: "Background Color")] ?? UIColor.init(red: 0.885, green: 0.934, blue: 1.000, alpha: 1.0).cgColor
    
   SettingsViewController.globalValues.newTextColor       =   SettingsViewController.globalValues.colorDict[UserDefaults.standard.string(forKey: "Text Color")] ?? UIColor.white.cgColor
    
}
