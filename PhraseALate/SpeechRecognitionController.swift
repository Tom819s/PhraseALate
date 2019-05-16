//
//  SpeechRecognition.swift
//  PhraseALate
//
//  Created by Thomas Martin on 5/9/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognitionController: UIViewController {
    
    @IBOutlet weak var transcriptionLabel: UILabel!
    
    @IBAction func translateButtonPressed(_ sender: Any) {
    }
    
    @IBAction func recordButton(_ sender: Any) {
        if (!isRecording)
        {
            do
            {
                try self.startRecording()
            }
            catch let error
            {
                print("There was a problem starting recording: \(error.localizedDescription)")
            }
            isRecording = true
            recordButton.backgroundColor = UIColor.init(red: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
            // 0.557 0.557  0.576
            //IOS Gray
            recordButton.setTitle("Stop", for: .normal)
        }
        else{
            stopRecording()
            isRecording = false
            recordButton.backgroundColor = UIColor.init(red: 0.0, green: 0.463, blue: 1.0, alpha: 1.0)
            //Red
            recordButton.setTitle("Record", for: .normal)
        }
        
    }//0,118,255)
    
    
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var translatedStr = String()
    var request = SFSpeechAudioBufferRecognitionRequest()
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    var recognitionTask: SFSpeechRecognitionTask?
    var chosenLanguage = 100
    var isRecording = false
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth : CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateButton.layer.cornerRadius = 5
        translateButton.layer.borderWidth = borderWidth
        translateButton.layer.borderColor = borderColor
        recordButton.layer.cornerRadius = recordButton.bounds.size.height
        recordButton.layer.borderWidth = borderWidth
        recordButton.layer.borderColor = borderColor
    }
    
    
    func startRecording() throws{
        
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        let recordingFormat = node.outputFormat(forBus: 0)
        
        // 2
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                self.transcriptionLabel.text = transcription.formattedString
            }
            
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionTask?.finish()
        recognitionTask = nil
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsController = segue.destination as! TranslateResultsController
        let phrase = transcriptionLabel.text!
        if phrase != ""
        {
            resultsController.chosenPhrase = phrase
            resultsController.chosenLanguageInt = self.chosenLanguage
        }
        else
        {
            resultsController.chosenPhrase = "Error Dictating Speech"
        }
        resultsController.chosenLanguageInt = 10
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
