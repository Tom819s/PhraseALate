//
//  langPickViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/31/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import CoreLocation

class LanguagePickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var chooseLangButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var isTranslate = false
    var isPhrase = false
    var isVoice = false
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    var countryCode = "TEST"
    var countryLang = "NULL"
    var tempLangCode = 99
    
    var languageData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageData.count
    }
    
    @IBAction func geolocatePressed(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: languageData[row], attributes:[NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.294, green: 0.463, blue: 0.918, alpha: 1.0)])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageData = ["Arabic", "Dutch", "Finnish", "French", "German", "Hindi", "Korean", "Portugese", "Russian", "Spanish", "Turkish"]
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        
        //locationManager code
        
        locationManager.delegate = self;
        if CLLocationManager.authorizationStatus() == .notDetermined{
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //since we're not navigating and only want a general idea of where the user is for country, no need for precision
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(sender is UIButton)
        {
                if (isTranslate) //if translating phrase we need to set the target viewcontroller's language field
                {
                    let translateController = segue.destination as! EnterTranslationController
                    if (self.tempLangCode == 99){
                        translateController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)}
                    else{
                        translateController.chosenLanguage = self.tempLangCode
                    }
                    
                }
                else if (isPhrase)
                {
                    let translateController = segue.destination as! PhraseSelectController
                    if (self.tempLangCode == 99){
                        translateController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)}
                    else{
                        translateController.chosenLanguage = self.tempLangCode
                    }
                }
                else if (isVoice)
                {
                    let speechController = segue.destination as! SpeechRecognitionController
                    if (self.tempLangCode == 99){
                        speechController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)}
                    else{
                        speechController.chosenLanguage = self.tempLangCode
                    }
                }
                
            }
        //set desti
        
    }
    
    
    @IBAction func chooseLangPressed(_ sender: Any) {
        playSound()
        if (isTranslate){
            self.performSegue(withIdentifier: "translate", sender: nil)
        }
        else if (isPhrase){
            self.performSegue(withIdentifier: "phrase", sender: nil)
        }
        else if (isVoice){
            self.performSegue(withIdentifier: "voice", sender: nil)
        }
        
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        geoCoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error) -> Void in
            if let validPlaceMark = placemarks?[0]
            {
                print(validPlaceMark.location?.coordinate as Any)
                self.countryCode = validPlaceMark.isoCountryCode!
                self.parseCountry()
                self.countryCodeLabel.isHidden = false
            }
            
            
        } )
    }
    func parseCountry(){
        if (countryCode != "TEST") //if country code was captured
        {
            switch(countryCode)
            {
            case "BF","BI","BJ","BL","CD","CG","CI","FR","GA","GF","GN","GP","MC","MF","ML","MQ","NC","NE","PF","PM","RE","SN","TF","TG","WF","YT","TD","DJ","CM","SC","HT","CF","MA":
                tempLangCode = 3 //french
                countryLang = "FR"
            case "AR","CL","CO","CR","CU","DO","EC","GT","HN","MX","NI","PA","PE","SV","UY","VE","PR","GQ","PY","BO":
                self.tempLangCode = 9 //spanish
                countryLang = "ES"
            case "ET","AE","BH","DZ","EG","JO","KW","LY","OM","QA","SA","SY","YE","SD","EH","LB","MR","TN","KM","PS","IQ":
                tempLangCode = 0 //arabic
                countryLang = "AR"
            case "AO","BR","CV","GW","MZ","PT","ST","TL":
                tempLangCode = 7 //portugese
                countryLang = "PT"
            case "BQ","NL","SR","CW","SX","BE", "AW":
                tempLangCode = 1 //dutch
                countryLang = "NL"
            case "AT","DE","LI":
                tempLangCode = 4 //german
                countryLang = "DE"
            case "KP", "KR":
                tempLangCode = 6 //korean
                countryLang = "KR"
            case "RU":
                tempLangCode = 8 //russian
                countryLang = "RU"
            case "TR":
                tempLangCode = 10 //turkish
                countryLang = "TR"
            case "IN":
                tempLangCode = 5 //hindi
                countryLang = "HI"
            default:
                tempLangCode = 99 //default non-supported language
                countryLang = "EN"
            }
            
            countryCodeLabel.text = countryCode + ": " + countryLang
    }
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

