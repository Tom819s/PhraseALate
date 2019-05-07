//
//  ThirdViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var translatedView: UILabel!
    @IBOutlet weak var phraseView: UILabel!
    
    
    
    var translatedString = String()
    var chosenPhrase = String()
    var chosenLanguageInt = Int()
    var chosenLanguageStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phraseView.text = chosenPhrase
        print(chosenLanguageInt)
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
                        }
                    
                }
                catch let jsonErr
                {
                    print("JSON decoding exception")
                    
                }
            }
        }.resume()
    }

    func languageIntToAPIStr(){
        switch (chosenLanguageInt){
            //"Spanish", "German", "Turkish", "Dutch", "French", "Finnish", "Russian"
            case 0:
            chosenLanguageStr = "en-es"
            case 1:
                chosenLanguageStr = "en-de"
            case 2:
                chosenLanguageStr = "en-tr"
            case 3:
                chosenLanguageStr = "en-nl"
            case 4:
                chosenLanguageStr = "en-fr"
            case 5:
                chosenLanguageStr = "en-fi"
            case 6:
                chosenLanguageStr = "en-ru"
            default:
                chosenLanguageStr = "en-es"
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
