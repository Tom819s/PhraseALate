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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phraseView.text = chosenPhrase
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
        let urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190330T143701Z.cb0abaf6f0e61f24.3678bc46520e369417f0949fcac8e2ecec2fb073&text=" + newString + "&lang=en-es"
        let url = URL(string: urlString)!
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let text = try JSONDecoder().decode(jsonResponse.self, from: data)
                    self.translatedString = text.text[0]
                    print(self.translatedString)
                    DispatchQueue.main.async{
                        self.translatedView.text = self.translatedString
                    }
                    
                } catch let jsonErr{
                    print("JSON decoding exception")
                    
                }
            }
            }.resume()
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
