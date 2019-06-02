//
//  ViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?


class TitlePageController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phrasesButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var currencyButton: customButton!
    
    var phraseChose = false
    var transChose = false
    var voiceChose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.layer.borderColor = UIColor.darkGray.cgColor
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.cornerRadius = 5
        SettingsViewController.globalValues.colorDict = [
            "lightbrown" : UIColor.init(red: 0.672, green: 0.637, blue: 0.568, alpha: 1.0).cgColor,
            "brown" : UIColor.init(red: 0.394, green: 0.253, blue: 0.000, alpha: 1.0).cgColor,
            "lightgray" : UIColor.lightGray.cgColor,
            "darkbackground" : UIColor.init(red: 0.100, green: 0.100, blue: 0.100, alpha: 1.0).cgColor,
            "darkblack" : UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor,
            "white" : UIColor.white.cgColor,
            "purple" : UIColor.purple.cgColor,
            "lightpurple" : UIColor.init(red: 0.557, green: 0.220, blue: 0.576, alpha: 1.0).cgColor,
            "lightblue" : UIColor.init(red: 0.885, green: 0.934, blue: 1.000, alpha: 1.0).cgColor,
            "darkblue" : UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 1.0).cgColor,
            "darkgray" : UIColor.darkGray.cgColor]
        
        loadSettings()
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(sender is UIButton)
        {
            let pickController = segue.destination as! LanguagePickerController
            pickController.isPhrase = phraseChose
            pickController.isTranslate = transChose
            pickController.isVoice = voiceChose
        }
        else{  
            playSound()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        self.setToTheme()
        
        
    }
    
    @IBAction func currencyPressed(_ sender: Any) {
        playSound()
    }
    
    @IBAction func phrasePressed(_ sender: Any) {
        phraseChose = true
        transChose = false
        voiceChose = false
        phraseChose = true
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    
    @IBAction func transPressed(_ sender: Any) {
        phraseChose = false
        voiceChose = false
        transChose = true
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    @IBAction func voicePressed(_ sender: Any) {
        phraseChose = false
        voiceChose = true
        transChose = false
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    func setToTheme(){
        titleLabel.backgroundColor            = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
        titleLabel.layer.borderColor          = SettingsViewController.globalValues.newBorderColor
        titleLabel.textColor                  = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
        
        phrasesButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        phrasesButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        phrasesButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        translateButton.layer.backgroundColor = SettingsViewController.globalValues.newButtonColor
        translateButton.layer.borderColor     = SettingsViewController.globalValues.newBorderColor
        translateButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        voiceButton.layer.backgroundColor     = SettingsViewController.globalValues.newButtonColor
        voiceButton.layer.borderColor         = SettingsViewController.globalValues.newBorderColor
        voiceButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        currencyButton.layer.backgroundColor     = SettingsViewController.globalValues.newButtonColor
        currencyButton.layer.borderColor         = SettingsViewController.globalValues.newBorderColor
        currencyButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        settingsButton.layer.backgroundColor  = SettingsViewController.globalValues.newButtonColor
        settingsButton.layer.borderColor      = SettingsViewController.globalValues.newBorderColor
        settingsButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
    }
    
}

func playSound() {
    
    if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
    
    guard let soundFile = Bundle.main.url(forResource: "buttonSound", withExtension: "wav")
        else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
        try AVAudioSession.sharedInstance().setActive(true)
        audioPlayer = try AVAudioPlayer(contentsOf: soundFile)
        audioPlayer?.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}

