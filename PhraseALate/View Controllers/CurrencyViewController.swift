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
    @IBOutlet weak var menuButton: customButton!
    @IBOutlet weak var updateRatesButton: customButton!
    @IBOutlet weak var geolocateButton: customButton!
    @IBOutlet weak var selectCurrencyButton: customButton!
    @IBOutlet weak var convertButton: customButton!
    @IBOutlet weak var sourceCurrencyLabel: UILabel!
    @IBOutlet weak var tableViewCurrency: UITableView!
    
    
    var dict: [String:String] = [:]
    var arrOfCountryStrings = [String]()
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
        tableViewCurrency.delegate = self
        tableViewCurrency.dataSource = self
        self.view.backgroundColor = UIColor(cgColor: SettingsViewController.globalValues.newBackgroundColor)
        try? dict = convertToDictionary()
        for (key, value) in dict{
            arrOfCountryStrings.append("\(key): \t\t \(value)")
        }
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
        tableViewCurrency.isHidden = false
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



extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfCountryStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency cell", for: indexPath)
            as! currencyCell
        let _countryString = arrOfCountryStrings[indexPath.row]
        cell.setCountry(countryString: _countryString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = self.arrOfCountryStrings[indexPath.row]
        self.countryCode = String(selectedCurrency.prefix(2))
        self.convertWanted = true
        playSound()
        getRates()
        tableViewCurrency.isHidden = true
    }
}

func getFlags(countryCode:  String) -> String
{
    
    switch(countryCode)
    {
    case "AD": return "🇦🇩"
    case "AE": return "🇦🇪"
    case "AF": return "🇦🇫"
    case "AG": return "🇦🇬"
    case "AI": return "🇦🇮"
    case "AL": return "🇦🇱"
    case "AM": return "🇦🇲"
    case "AO": return "🇦🇴"
    case "AQ": return "🇦🇶"
    case "AR": return "🇦🇷"
    case "AS": return "🇦🇸"
    case "AT": return "🇦🇹"
    case "AU": return "🇦🇺"
    case "AW": return "🇦🇼"
    case "AX": return "🇦🇽"
    case "AZ": return "🇦🇿"
    case "BA": return "🇧🇦"
    case "BB": return "🇧🇧"
    case "BD": return "🇧🇩"
    case "BE": return "🇧🇪"
    case "BF": return "🇧🇫"
    case "BG": return "🇧🇬"
    case "BH": return "🇧🇭"
    case "BI": return "🇧🇮"
    case "BJ": return "🇧🇯"
    case "BL": return "🇧🇱"
    case "BM": return "🇧🇲"
    case "BN": return "🇧🇳"
    case "BO": return "🇧🇴"
    case "BQ": return "🇧🇶"
    case "BR": return "🇧🇷"
    case "BS": return "🇧🇸"
    case "BT": return "🇧🇹"
    case "BV": return "🇧🇻"
    case "BW": return "🇧🇼"
    case "BY": return "🇧🇾"
    case "BZ": return "🇧🇿"
    case "CA": return "🇨🇦"
    case "CC": return "🇨🇨"
    case "CD": return "🇨🇩"
    case "CF": return "🇨🇫"
    case "CG": return "🇨🇬"
    case "CH": return "🇨🇭"
    case "CI": return "🇨🇮"
    case "CK": return "🇨🇰"
    case "CL": return "🇨🇱"
    case "CM": return "🇨🇲"
    case "CN": return "🇨🇳"
    case "CO": return "🇨🇴"
    case "CR": return "🇨🇷"
    case "CU": return "🇨🇺"
    case "CV": return "🇨🇻"
    case "CW": return "🇨🇼"
    case "CX": return "🇨🇽"
    case "CY": return "🇨🇾"
    case "CZ": return "🇨🇿"
    case "DE": return "🇩🇪"
    case "DJ": return "🇩🇯"
    case "DK": return "🇩🇰"
    case "DM": return "🇩🇲"
    case "DO": return "🇩🇴"
    case "DZ": return "🇩🇿"
    case "EC": return "🇪🇨"
    case "EE": return "🇪🇪"
    case "EG": return "🇪🇬"
    case "EH": return "🇪🇭"
    case "ER": return "🇪🇷"
    case "ES": return "🇪🇸"
    case "ET": return "🇪🇹"
    case "FI": return "🇫🇮"
    case "FJ": return "🇫🇯"
    case "FK": return "🇫🇰"
    case "FM": return "🇫🇲"
    case "FO": return "🇫🇴"
    case "FR": return "🇫🇷"
    case "GA": return "🇬🇦"
    case "GB": return "🇬🇧"
    case "GD": return "🇬🇩"
    case "GE": return "🇬🇪"
    case "GF": return "🇬🇫"
    case "GG": return "🇬🇬"
    case "GH": return "🇬🇭"
    case "GI": return "🇬🇮"
    case "GL": return "🇬🇱"
    case "GM": return "🇬🇲"
    case "GN": return "🇬🇳"
    case "GP": return "🇬🇵"
    case "GQ": return "🇬🇶"
    case "GR": return "🇬🇷"
    case "GS": return "🇬🇸"
    case "GT": return "🇬🇹"
    case "GU": return "🇬🇺"
    case "GW": return "🇬🇼"
    case "GY": return "🇬🇾"
    case "HK": return "🇭🇰"
    case "HM": return "🇭🇲"
    case "HN": return "🇭🇳"
    case "HR": return "🇭🇷"
    case "HT": return "🇭🇹"
    case "HU": return "🇭🇺"
    case "ID": return "🇮🇩"
    case "IE": return "🇮🇪"
    case "IL": return "🇮🇱"
    case "IM": return "🇮🇲"
    case "IN": return "🇮🇳"
    case "IO": return "🇮🇴"
    case "IQ": return "🇮🇶"
    case "IR": return "🇮🇷"
    case "IS": return "🇮🇸"
    case "IT": return "🇮🇹"
    case "JE": return "🇯🇪"
    case "JM": return "🇯🇲"
    case "JO": return "🇯🇴"
    case "JP": return "🇯🇵"
    case "KE": return "🇰🇪"
    case "KG": return "🇰🇬"
    case "KH": return "🇰🇭"
    case "KI": return "🇰🇮"
    case "KM": return "🇰🇲"
    case "KN": return "🇰🇳"
    case "KP": return "🇰🇵"
    case "KR": return "🇰🇷"
    case "KW": return "🇰🇼"
    case "KY": return "🇰🇾"
    case "KZ": return "🇰🇿"
    case "LA": return "🇱🇦"
    case "LB": return "🇱🇧"
    case "LC": return "🇱🇨"
    case "LI": return "🇱🇮"
    case "LK": return "🇱🇰"
    case "LR": return "🇱🇷"
    case "LS": return "🇱🇸"
    case "LT": return "🇱🇹"
    case "LU": return "🇱🇺"
    case "LV": return "🇱🇻"
    case "LY": return "🇱🇾"
    case "MA": return "🇲🇦"
    case "MC": return "🇲🇨"
    case "MD": return "🇲🇩"
    case "ME": return "🇲🇪"
    case "MF": return "🇲🇫"
    case "MG": return "🇲🇬"
    case "MH": return "🇲🇭"
    case "MK": return "🇲🇰"
    case "ML": return "🇲🇱"
    case "MM": return "🇲🇲"
    case "MN": return "🇲🇳"
    case "MO": return "🇲🇴"
    case "MP": return "🇲🇵"
    case "MQ": return "🇲🇶"
    case "MR": return "🇲🇷"
    case "MS": return "🇲🇸"
    case "MT": return "🇲🇹"
    case "MU": return "🇲🇺"
    case "MV": return "🇲🇻"
    case "MW": return "🇲🇼"
    case "MX": return "🇲🇽"
    case "MY": return "🇲🇾"
    case "MZ": return "🇲🇿"
    case "NA": return "🇳🇦"
    case "NC": return "🇳🇨"
    case "NE": return "🇳🇪"
    case "NF": return "🇳🇫"
    case "NG": return "🇳🇬"
    case "NI": return "🇳🇮"
    case "NL": return "🇳🇱"
    case "NO": return "🇳🇴"
    case "NP": return "🇳🇵"
    case "NR": return "🇳🇷"
    case "NU": return "🇳🇺"
    case "NZ": return "🇳🇿"
    case "OM": return "🇴🇲"
    case "PA": return "🇵🇦"
    case "PE": return "🇵🇪"
    case "PF": return "🇵🇫"
    case "PG": return "🇵🇬"
    case "PH": return "🇵🇭"
    case "PK": return "🇵🇰"
    case "PL": return "🇵🇱"
    case "PM": return "🇵🇲"
    case "PN": return "🇵🇳"
    case "PR": return "🇵🇷"
    case "PS": return "🇵🇸"
    case "PT": return "🇵🇹"
    case "PW": return "🇵🇼"
    case "PY": return "🇵🇾"
    case "QA": return "🇶🇦"
    case "RE": return "🇷🇪"
    case "RO": return "🇷🇴"
    case "RS": return "🇷🇸"
    case "RU": return "🇷🇺"
    case "RW": return "🇷🇼"
    case "SA": return "🇸🇦"
    case "SB": return "🇸🇧"
    case "SC": return "🇸🇨"
    case "SD": return "🇸🇩"
    case "SE": return "🇸🇪"
    case "SG": return "🇸🇬"
    case "SH": return "🇸🇭"
    case "SI": return "🇸🇮"
    case "SJ": return "🇸🇯"
    case "SK": return "🇸🇰"
    case "SL": return "🇸🇱"
    case "SM": return "🇸🇲"
    case "SN": return "🇸🇳"
    case "SO": return "🇸🇴"
    case "SR": return "🇸🇷"
    case "SS": return "🇸🇸"
    case "ST": return "🇸🇹"
    case "SV": return "🇸🇻"
    case "SX": return "🇸🇽"
    case "SY": return "🇸🇾"
    case "SZ": return "🇸🇿"
    case "TC": return "🇹🇨"
    case "TD": return "🇹🇩"
    case "TF": return "🇹🇫"
    case "TG": return "🇹🇬"
    case "TH": return "🇹🇭"
    case "TJ": return "🇹🇯"
    case "TK": return "🇹🇰"
    case "TL": return "🇹🇱"
    case "TM": return "🇹🇲"
    case "TN": return "🇹🇳"
    case "TO": return "🇹🇴"
    case "TR": return "🇹🇷"
    case "TT": return "🇹🇹"
    case "TV": return "🇹🇻"
    case "TW": return "🇹🇼"
    case "TZ": return "🇹🇿"
    case "UA": return "🇺🇦"
    case "UG": return "🇺🇬"
    case "UM": return "🇺🇲"
    case "US": return "🇺🇸"
    case "UY": return "🇺🇾"
    case "UZ": return "🇺🇿"
    case "VA": return "🇻🇦"
    case "VC": return "🇻🇨"
    case "VE": return "🇻🇪"
    case "VG": return "🇻🇬"
    case "VI": return "🇻🇮"
    case "VN": return "🇻🇳"
    case "VU": return "🇻🇺"
    case "WF": return "🇼🇫"
    case "WS": return "🇼🇸"
    case "XK": return "🇽🇰"
    case "YE": return "🇾🇪"
    case "YT": return "🇾🇹"
    case "ZA": return "🇿🇦"
    case "ZM": return "🇿🇲"
    default: return "🏳"
    }
}
