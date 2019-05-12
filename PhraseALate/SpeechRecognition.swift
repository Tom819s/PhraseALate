//
//  SpeechRecognition.swift
//  PhraseALate
//
//  Created by Thomas Martin on 5/9/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognition: UIViewController {
    
    @IBOutlet weak var transcriptionLabel: UILabel!
    
    @IBAction func translateButtonPressed(_ sender: Any) {
    }
    @IBAction func recordButton(_ sender: Any) {        do {
        try self.startRecording()
    } catch let error {
        print("There was a problem starting recording: \(error.localizedDescription)")
        }
    }
    
    @IBAction func stopRecordButton(_ sender: Any) {
        stopRecording()
    }
    
    var translatedStr = String()
    var request = SFSpeechAudioBufferRecognitionRequest()
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
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
