//
//  langPickViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/31/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit

class langPickViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagePicker: UIPickerView!
    var isTranslate = false
    var isPhrase = false
    
    var languageData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: languageData[row], attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageData = ["Spanish", "German", "Turkish", "Dutch", "French", "Finnish", "Russian"]
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //setup code for
        //seguelabelTest.text = languagePicker.selectedRowInComponent(0)
        if (isTranslate) //if translating phrase we need to set the target viewcontroller's language field
        {
            let translateController = segue.destination as! FourthViewController
            translateController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)
        }
        else
        {
            let translateController = segue.destination as! SecondViewController
            translateController.chosenLanguage = languagePicker.selectedRow(inComponent: 0)
        }
        //set destination viewcontroller to recieve pickerView's language value for API request
    }
    
    
    @IBAction func chooseLangPressed(_ sender: Any) {
        if (isTranslate){
            self.performSegue(withIdentifier: "translate", sender: nil)
        }
        else{
        self.performSegue(withIdentifier: "phrase", sender: nil)
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
