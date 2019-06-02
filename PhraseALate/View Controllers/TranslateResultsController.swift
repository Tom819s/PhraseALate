//
//  ThirdViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateResultsController: UIViewController {
    
    @IBOutlet weak var translatedView: UILabel!
    @IBOutlet weak var phraseView: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var playbackLabel: UILabel!
    @IBOutlet weak var sliderSpeed: UISlider!
    
    var translatedString            = String()
    var chosenPhrase                = String()
    var voiceLanguage               = String()
    var chosenLanguageInt           = Int()
    var chosenLanguageStr           = String()
    var hasTranslated               = false
    let speechSynth                 = AVSpeechSynthesizer()
    var utteranceSpeed: Float       = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        setToTheme()
        phraseView.text = chosenPhrase
        languageIntToAPIStr()
        translate()
        // Do any additional setup after loading the view.
    }
    @IBAction func sliderChanged(_ sender: Any) {
        let slider = sender as! UISlider
        utteranceSpeed = slider.value
    }
    
    struct jsonResponse: Decodable{
        let code:Int
        let lang:String
        let text:[String]
    }
    
    func translate ()
    {
        
        let formattedString = chosenPhrase.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190330T143701Z.cb0abaf6f0e61f24.3678bc46520e369417f0949fcac8e2ecec2fb073&text=" + formattedString + "&lang=" + chosenLanguageStr
        let url = URL(string: urlString)!
        
        //https://translate.yandex.net/api/v1.5/tr.json/getLangs
        
        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let data = data
            {
                do
                {
                    let text = try JSONDecoder().decode(jsonResponse.self, from: data)
                    self.translatedString = text.text[0]
                    DispatchQueue.main.async
                        {
                            self.translatedView.text = self.translatedString
                            self.hasTranslated = true
                            self.speakOutLoud()
                    }
                }
                catch _
                {
                    print("JSON decoding exception")
                    self.translatedView.text = "Error: Try Again"
                }
            }
            }.resume()
    }
    
    @IBAction func speakAgainPressed(_ sender: Any)
    {
        playSound()
        if hasTranslated
        {
            self.speakOutLoud()
        }
    }
    
    func languageIntToAPIStr(){
        switch (chosenLanguageInt){
        //"Dutch", "Finnish", "French", "German", "Hindi", "Korean", "Portugese", "Russian", "Spanish", "Turkish"
        case 0:
            chosenLanguageStr = "ar"
            voiceLanguage = "ar-SA"
        case 1:
            chosenLanguageStr = "en-nl"
            voiceLanguage = "nl-NL"
        case 2:
            chosenLanguageStr = "en-fi"
            voiceLanguage = "fi-FI"
        case 3:
            chosenLanguageStr = "en-fr"
            voiceLanguage = "fr-FR"
        case 4:
            chosenLanguageStr = "en-de"
            voiceLanguage = "da-DK"
        case 5:
            chosenLanguageStr = "hi"
            voiceLanguage = "hi-IN"
        case 6:
            chosenLanguageStr = "ko"
            voiceLanguage = "ko-KR"
        case 7:
            chosenLanguageStr = "en-pt"
            voiceLanguage = "pt-BR"
        case 8:
            chosenLanguageStr = "en-ru"
            voiceLanguage = "ru-RU"
        case 9:
            chosenLanguageStr = "en-es"
            voiceLanguage = "es-MX"
        case 10:
            chosenLanguageStr = "en-tr"
            voiceLanguage = "tr-TR"
        default:
            chosenLanguageStr = "en-es"
            voiceLanguage = "es-MX"
        }
    }
    
    func speakOutLoud(){
        let translatedNoPunctuation = translatedString.components(separatedBy: CharacterSet.punctuationCharacters).joined()
        let utterance               = AVSpeechUtterance(string: translatedNoPunctuation)
        utterance.volume            = 1.0
        utterance.rate              = utteranceSpeed
        utterance.voice             = AVSpeechSynthesisVoice(language: voiceLanguage)
        speechSynth.speak(utterance)
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setToTheme(){
        
        menuButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        menuButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        menuButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        replayButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        replayButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        replayButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        translatedView.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        translatedView.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        
        if SettingsViewController.globalValues.newButtonColor == UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 1.0).cgColor
        {
            
            playbackLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
            translatedView.textColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
            phraseView.textColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
        }
        else
        {
            
            playbackLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
            translatedView.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
            phraseView.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
        }
        
        phraseView.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        phraseView.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        
        sliderSpeed.tintColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
        
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
