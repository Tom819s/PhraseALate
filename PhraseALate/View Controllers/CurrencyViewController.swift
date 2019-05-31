//
//  CurrencyViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 5/28/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import CoreLocation

class CurrencyViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var USDBox: UITextField!
    @IBOutlet weak var targetCurrencyBox: UITextField!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var menuButton: customButton!
    @IBOutlet weak var updateRatesButton: customButton!
    @IBOutlet weak var geolocateButton: customButton!
    @IBOutlet weak var selectCurrencyButton: customButton!
    @IBOutlet weak var convertButton: customButton!
    @IBOutlet weak var sourceCurrencyLabel: UILabel!
    
    
    var dict: [String:String] = [:]
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    var countryCode = "DE"
    var conversionRate : Double = 0.00
    var apiURL = "https://api.exchangeratesapi.io/latest?base=USD&symbols=USD,"
    var convertWanted = false
    let numberToolbar : UIToolbar = UIToolbar()
    
    struct jsonResponse: Decodable{
        let base:String
        let rates:[String: Double]
        let date: String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        try? dict = convertToDictionary()
        setToTheme()
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CurrencyViewController.doneEnteringNumbers))
        ]
        numberToolbar.sizeToFit()
        USDBox.inputAccessoryView = numberToolbar
        
        locationManager.delegate = self;
        if CLLocationManager.authorizationStatus() == .notDetermined{
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        playSound()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func geoLocatePressed(_ sender: Any) {
        self.convertWanted = true
        playSound()
        locationManager.startUpdatingLocation()
        getRates()
    }
    
    @IBAction func selectCurrencyPressed(_ sender: Any) {
        playSound()
        currencyTableView.isHidden = false
    }
    
    @IBAction func updateRatesPressed(_ sender: Any) {
        playSound()
        getRates()
    }
    
    @IBAction func convertPressed(_ sender: Any) {
        playSound()
        convertAtRate()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        geoCoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error) -> Void in
            if let validPlaceMark = placemarks?[0]
            {
                self.countryCode = validPlaceMark.isoCountryCode!
                self.getRates()
            }
            
            
        } )
    }
    
    @objc func doneEnteringNumbers () {
        USDBox.resignFirstResponder()
    }
    
    func parseNumericalEntryOfExtraneousDecimals(){
        var workingString = USDBox.text
        let needle: Character = "."
        if let index = workingString!.index(of: needle) {
            workingString = workingString?.replacingOccurrences(of: ".", with: "")
            workingString?.insert(".", at: index)
            USDBox.text = workingString
        }
        
    }
        
    
    func getRates(){
        
        let url = URL(string: apiURL + dict[countryCode]!)!
        
        print(url)
        
        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let data = data
            {
                do
                {
                    let text = try JSONDecoder().decode(jsonResponse.self, from: data)
                    DispatchQueue.main.async
                        {
                            self.conversionRate = text.rates[self.dict[self.countryCode]!]!
                            self.targetCurrencyLabel.text = String(format: "%.2f", self.conversionRate) + " " + self.dict[self.countryCode]!
                            
                            if self.convertWanted == true {
                                self.convertAtRate()
                                self.convertWanted = false
                            }
                    }
                }
                catch _
                {
                    print("JSON decoding exception")
                }
            }
            }.resume()
    }
    
    func convertAtRate(){
        if (conversionRate == 0.00)
        {
            self.convertWanted = true
            getRates()
        }
        parseNumericalEntryOfExtraneousDecimals()
        let amount = Double(USDBox.text!)
        targetCurrencyBox.text = String(format: "%.2f", amount! * conversionRate)
        self.targetCurrencyLabel.text = String(format: "%.2f", self.conversionRate) + " " + self.dict[self.countryCode]!
        
    }
    
    
    func convertToDictionary() throws -> [String: String] {
        let text = """
{"BD": "BDT", "BE": "EUR", "BF": "XOF", "BG": "BGN", "BA": "BAM", "BB": "BBD", "WF": "XPF", "BL": "EUR", "BM": "BMD", "BN": "BND", "BO": "BOB", "BH": "BHD", "BI": "BIF", "BJ": "XOF", "BT": "BTN", "JM": "JMD", "BV": "NOK", "BW": "BWP", "WS": "WST", "BQ": "USD", "BR": "BRL", "BS": "BSD", "JE": "GBP", "BY": "BYR", "BZ": "BZD", "RU": "RUB", "RW": "RWF", "RS": "RSD", "TL": "USD", "RE": "EUR", "TM": "TMT", "TJ": "TJS", "RO": "RON", "TK": "NZD", "GW": "XOF", "GU": "USD", "GT": "GTQ", "GS": "GBP", "GR": "EUR", "GQ": "XAF", "GP": "EUR", "JP": "JPY", "GY": "GYD", "GG": "GBP", "GF": "EUR", "GE": "GEL", "GD": "XCD", "GB": "GBP", "GA": "XAF", "SV": "USD", "GN": "GNF", "GM": "GMD", "GL": "DKK", "GI": "GIP", "GH": "GHS", "OM": "OMR", "TN": "TND", "JO": "JOD", "HR": "HRK", "HT": "HTG", "HU": "HUF", "HK": "HKD", "HN": "HNL", "HM": "AUD", "VE": "VEF", "PR": "USD", "PS": "ILS", "PW": "USD", "PT": "EUR", "SJ": "NOK", "PY": "PYG", "IQ": "IQD", "PA": "PAB", "PF": "XPF", "PG": "PGK", "PE": "PEN", "PK": "PKR", "PH": "PHP", "PN": "NZD", "PL": "PLN", "PM": "EUR", "ZM": "ZMK", "EH": "MAD", "EE": "EUR", "EG": "EGP", "ZA": "ZAR", "EC": "USD", "IT": "EUR", "VN": "VND", "SB": "SBD", "ET": "ETB", "SO": "SOS", "ZW": "ZWL", "SA": "SAR", "ES": "EUR", "ER": "ERN", "ME": "EUR", "MD": "MDL", "MG": "MGA", "MF": "EUR", "MA": "MAD", "MC": "EUR", "UZ": "UZS", "MM": "MMK", "ML": "XOF", "MO": "MOP", "MN": "MNT", "MH": "USD", "MK": "MKD", "MU": "MUR", "MT": "EUR", "MW": "MWK", "MV": "MVR", "MQ": "EUR", "MP": "USD", "MS": "XCD", "MR": "MRO", "IM": "GBP", "UG": "UGX", "TZ": "TZS", "MY": "MYR", "MX": "MXN", "IL": "ILS", "FR": "EUR", "IO": "USD", "SH": "SHP", "FI": "EUR", "FJ": "FJD", "FK": "FKP", "FM": "USD", "FO": "DKK", "NI": "NIO", "NL": "EUR", "NO": "NOK", "NA": "NAD", "VU": "VUV", "NC": "XPF", "NE": "XOF", "NF": "AUD", "NG": "NGN", "NZ": "NZD", "NP": "NPR", "NR": "AUD", "NU": "NZD", "CK": "NZD", "XK": "EUR", "CI": "XOF", "CH": "CHF", "CO": "COP", "CN": "CNY", "CM": "XAF", "CL": "CLP", "CC": "AUD", "CA": "CAD", "CG": "XAF", "CF": "XAF", "CD": "CDF", "CZ": "CZK", "CY": "EUR", "CX": "AUD", "CR": "CRC", "CW": "ANG", "CV": "CVE", "CU": "CUP", "SZ": "SZL", "SY": "SYP", "SX": "ANG", "KG": "KGS", "KE": "KES", "SS": "SSP", "SR": "SRD", "KI": "AUD", "KH": "KHR", "KN": "XCD", "KM": "KMF", "ST": "STD", "SK": "EUR", "KR": "KRW", "SI": "EUR", "KP": "KPW", "KW": "KWD", "SN": "XOF", "SM": "EUR", "SL": "SLL", "SC": "SCR", "KZ": "KZT", "KY": "KYD", "SG": "SGD", "SE": "SEK", "SD": "SDG", "DO": "DOP", "DM": "XCD", "DJ": "DJF", "DK": "DKK", "VG": "USD", "DE": "EUR", "YE": "YER", "DZ": "DZD", "US": "USD", "UY": "UYU", "YT": "EUR", "UM": "USD", "LB": "LBP", "LC": "XCD", "LA": "LAK", "TV": "AUD", "TW": "TWD", "TT": "TTD", "TR": "TRY", "LK": "LKR", "LI": "CHF", "LV": "EUR", "TO": "TOP", "LT": "LTL", "LU": "EUR", "LR": "LRD", "LS": "LSL", "TH": "THB", "TF": "EUR", "TG": "XOF", "TD": "XAF", "TC": "USD", "LY": "LYD", "VA": "EUR", "VC": "XCD", "AE": "AED", "AD": "EUR", "AG": "XCD", "AF": "AFN", "AI": "XCD", "VI": "USD", "IS": "ISK", "IR": "IRR", "AM": "AMD", "AL": "ALL", "AO": "AOA", "AQ": "", "AS": "USD", "AR": "ARS", "AU": "AUD", "AT": "EUR", "AW": "AWG", "IN": "INR", "AX": "EUR", "AZ": "AZN", "IE": "EUR", "ID": "IDR", "UA": "UAH", "QA": "QAR", "MZ": "MZN"}
"""
        
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
    func setToTheme(){
        /*
         USDBox: UITextField!
         targetCurrencyBox: UITextField!
         targetCurrencyLabel: UILabel!
         currencyTableView: UITableView!
         
         menuButton: customButton!
         updateRatesButton: customButton!
         geolocateButton: customButton!
         selectCurrencyButton: customButton!
         convertButton: customButton!
         
         */
        
        menuButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        menuButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        menuButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        updateRatesButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        updateRatesButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        updateRatesButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        geolocateButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        geolocateButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        geolocateButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        selectCurrencyButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        selectCurrencyButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        selectCurrencyButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        convertButton.layer.backgroundColor   = SettingsViewController.globalValues.newButtonColor
        convertButton.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        convertButton.setTitleColor(UIColor(cgColor: SettingsViewController.globalValues.newTextColor), for: .normal)
        
        USDBox.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        USDBox.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        USDBox.textColor  = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
        
        
        targetCurrencyBox.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        targetCurrencyBox.layer.borderColor       = SettingsViewController.globalValues.newBorderColor
        targetCurrencyBox.textColor  = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
        
        targetCurrencyLabel.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        targetCurrencyLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
        
        sourceCurrencyLabel.layer.backgroundColor   = SettingsViewController.globalValues.newBackgroundColor
        sourceCurrencyLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newTextColor)
        
        if SettingsViewController.globalValues.newButtonColor == UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 1.0).cgColor{
            sourceCurrencyLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
            targetCurrencyLabel.textColor = UIColor(cgColor: SettingsViewController.globalValues.newButtonColor)
            
        }
        
    }
    
    
}
