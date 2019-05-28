//
//  ViewController.swift
//  PhraseALate
//
//  Created by Thomas Martin on 3/30/19.
//  Copyright © 2019 Thomas Martin. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?


class TitlePageController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phrasesButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    
    var phraseChose = false
    var transChose = false
    var voiceChose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(sender is UIButton)
        {
            let pickController = segue.destination as! LanguagePickerController
            pickController.isPhrase = phraseChose
            pickController.isTranslate = transChose
            pickController.isVoice = voiceChose
        }

    }
    
    @IBAction func currencyPressed(_ sender: Any) {
        playSound()
    }
    
    @IBAction func phrasePressed(_ sender: Any) {
        phraseChose = true
        transChose = false
        voiceChose = false
        phraseChose = true
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    
    @IBAction func transPressed(_ sender: Any) {
        phraseChose = false
        voiceChose = false
        transChose = true
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    @IBAction func voicePressed(_ sender: Any) {
        phraseChose = false
        voiceChose = true
        transChose = false
        playSound()
        self.performSegue(withIdentifier: "langPick", sender: nil)
    }
    
    
}

func playSound() {
    
    if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
    
    guard let soundFile = Bundle.main.url(forResource: "buttonSound", withExtension: "wav")
        else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
        try AVAudioSession.sharedInstance().setActive(true)
        audioPlayer = try AVAudioPlayer(contentsOf: soundFile)
        audioPlayer?.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}

