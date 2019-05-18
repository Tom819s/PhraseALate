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
    
    var translatedString = String()
    var chosenPhrase = String()
    var voiceLanguage = String()
    var chosenLanguageInt = Int()
    var chosenLanguageStr = String()
    var hasTranslated = false
    let speechSynth = AVSpeechSynthesizer()
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth : CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseView.text = chosenPhrase
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        replayButton.layer.cornerRadius = 5
        replayButton.layer.borderWidth = borderWidth
        replayButton.layer.borderColor = borderColor
        languageIntToAPIStr()
        translate()
        // Do any additional setup after loading the view.
    }
    
    struct jsonResponse: Decodable{
        let code:Int
        let lang:String
        let text:[String]
    }
    
    func translate ()
    {
        
        let newString = chosenPhrase.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190330T143701Z.cb0abaf6f0e61f24.3678bc46520e369417f0949fcac8e2ecec2fb073&text=" + newString + "&lang=" + chosenLanguageStr
        let url = URL(string: urlString)!
        
        //https://translate.yandex.net/api/v1.5/tr.json/getLangs
        
        let task = URLSession.shared.dataTask(with: url)
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
                catch let jsonErr
                {
                    print("JSON decoding exception")
                    self.translatedView.text = "Error: Try Again"
                }
            }
            }.resume()
    }
    
    @IBAction func speakAgainPressed(_ sender: Any)
    {
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
        let utterance = AVSpeechUtterance(string: translatedNoPunctuation)
        utterance.volume = 1.0
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        speechSynth.speak(utterance)
    }
    
    @IBAction func menuPressed(_ sender: Any) { self.navigationController?.popToRootViewController(animated: true)
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
