//
//  FirstViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/20/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SnapKit

class FirstViewController: UIViewController, SFSpeechRecognizerDelegate {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var isFinal = false
    var isAlreadyPushed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        let synthesizer = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: "Welcome to Easy Access. Touch the bottom of the Screen and say Continue if you like for me to continue speaking")
        myUtterance.rate = 0.50
        myUtterance.pitchMultiplier = 1.0
        myUtterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
        synthesizer.speak(myUtterance)
        
        self.recordButton.addTarget(self , action: #selector(recordButtonWasTapped), for: .touchUpInside)
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    func startRecording() throws {
        
        if let recognitionTask  = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            self.isFinal = false
            if let result = result {
                let results = result.bestTranscription.formattedString
                self.textView.text = result.bestTranscription.formattedString
                self.isFinal = result.isFinal
       
                if results == "Resources" || results == "Resource"{
                    
                    if self.isAlreadyPushed == false {
                        self.navigationController?.pushViewController(SocialServicesTableViewController(), animated: true)
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Stopping", for: .disabled)
                        self.isAlreadyPushed = true
                    }
                    
                } else if results == "Local service" || results == "Local services" {
                    if self.isAlreadyPushed == false {
                        self.navigationController?.pushViewController(MapViewController(), animated: true)
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Stopping", for: .disabled)
                        self.isAlreadyPushed = true
                    }
                }
            }
            self.recordButton.isEnabled = true
            
            if error != nil || self.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        textView.text = "(Go ahead, I'm listening)"
        textView.font = UIFont.systemFont(ofSize: 30.0)
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    func viewHiearchy() {
        self.edgesForExtendedLayout = []
        self.view.addSubview(textView)
        self.view.addSubview(recordButton)
        self.view.addSubview(serviceButton)
        self.view.addSubview(resourcesButton)
        
    }
    
    func configureConstraints() {
        textView.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.40)
            
        }
        recordButton.snp.makeConstraints { (button) in
            button.leading.trailing.bottom.equalToSuperview()
    
         }
        serviceButton.snp.makeConstraints { (button) in
            button.leading.equalToSuperview()
            button.trailing.equalTo(self.view.snp.centerX)
            button.size.equalTo(100)
        
        }
        resourcesButton.snp.makeConstraints { (button) in
            button.trailing.equalToSuperview()
            button.leading.equalTo(self.view.snp.centerX)
            button.size.equalTo(100)
            
        }
    }
    
    // MARK: - Button Function
    
    func recordButtonWasTapped() {
        print("I'm trapped")
        self.isAlreadyPushed = false
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    
    
    // MARK: -  UI Objects
    lazy var textView: UITextView = {
        let text = UITextView()
        //text.backgroundColor = .blue
        text.font = UIFont(name: "system", size: 40.0)
        text.isUserInteractionEnabled = false
        return text
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Start Recording", for: .normal)
        
        return button
        
    }()
  
    lazy var serviceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Local Services", for: .normal)
        return button
        
    }()
    lazy var resourcesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Resouces", for: .normal)
        return button
        
    }()
    
}
