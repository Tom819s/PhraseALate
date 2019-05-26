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
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth : CGFloat = 2.0
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    var countryCode = "TEST"
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
        chooseLangButton.layer.cornerRadius = 5
        chooseLangButton.layer.borderWidth = borderWidth
        chooseLangButton.layer.borderColor = borderColor
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        
        //locationManager code
        
        locationManager.delegate = self;
        if CLLocationManager.authorizationStatus() == .notDetermined{
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //since we're not navigating and only want a general idea of where the user is for country, no need for precision
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //setup code for
        //seguelabelTest.text = languagePicker.selectedRowInComponent(0)
        if !(sender is UIButton)
        {
            if (countryCode != "TEST") //if country code was captured
            {
                switch(countryCode)
                {
                case "BF","BI","BJ","BL","CD","CG","CI","FR","GA","GF","GN","GP","MC","MF","ML","MQ","NC","NE","PF","PM","RE","SN","TF","TG","WF","YT","TD","DJ","CM","SC","HT","CF","MA":
                    tempLangCode = 3
                case "AR","CL","CO","CR","CU","DO","EC","GT","HN","MX","NI","PA","PE","SV","UY","VE","PR","GQ","PY","BO":
                    self.tempLangCode = 9; //spanish
                case "ET","AE","BH","DZ","EG","JO","KW","LY","OM","QA","SA","SY","YE","SD","EH","LB","MR","TN","KM","PS","IQ"://arabic
                    tempLangCode = 0
                case "AO","BR","CV","GW","MZ","PT","ST","TL":
                    tempLangCode = 7
                case "BQ","NL","SR","CW","SX","BE", "AW":
                    tempLangCode = 1
                case "AT","DE","LI":
                    tempLangCode = 4
                case "KP", "KR":
                    tempLangCode = 6
                case "RU":
                    tempLangCode = 8
                case "TR":
                    tempLangCode = 10
                default:
                    tempLangCode = 99
                }
                
                if (isTranslate) //if translating phrase we need to set the target viewcontroller's language field
                {
                    let translateController = segue.destination as! EnterTranslationController
                    if (self.tempLangCode == 99){
                        translateController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)}
                    else{
                    translateController.chosenLanguage = self.tempLangCode
                    }
                    
                }                else if (isPhrase)
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
            //set destination viewcontroller to recieve pickerView's language value for API request
        }
        
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
    
    @IBAction func menuPressed(_ sender: Any) { self.navigationController?.popToRootViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        geoCoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error) -> Void in
            if let validPlaceMark = placemarks?[0]
            {
                print(validPlaceMark.location?.coordinate as Any)
                self.countryCode = validPlaceMark.isoCountryCode!
                self.countryCodeLabel.text = self.countryCode
            }
            
            
        } )
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
