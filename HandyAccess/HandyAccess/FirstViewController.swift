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
        viewHiearchy()
        configureConstraints()
        view.backgroundColor = .white
        self.textView.text = "How Can I Help You? 😊"
        self.resourcesButton.addTarget(self, action: #selector(resourcesButtonWasTapped), for: .touchUpInside)
        self.serviceButton.addTarget(self, action: #selector(serviceButtonWasTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        let synthesizer = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: "Welcome to Easy Access. Touch the bottom of the Screen and say Continue. This will allow me to speak even more")
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
       
                if results == "Continue"{
                    
                    if self.isAlreadyPushed == false {
                        self.navigationController?.pushViewController(InitialViewController(), animated: true)
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
            view.height.equalToSuperview().multipliedBy(0.50)
            
        }
        recordButton.snp.makeConstraints { (button) in
            button.leading.trailing.bottom.equalToSuperview()
            button.size.equalTo(200)
    
         }
        serviceButton.snp.makeConstraints { (button) in
            button.leading.equalToSuperview()
            button.trailing.equalTo(self.view.snp.centerX)
            button.size.equalTo(100)
            button.top.equalTo(textView.snp.bottom)
        
        }
        resourcesButton.snp.makeConstraints { (button) in
            button.trailing.equalToSuperview()
            button.leading.equalTo(self.view.snp.centerX)
            button.size.equalTo(100)
            button.top.equalTo(textView.snp.bottom)
        }
    }
    
    // MARK: - Button Function
    
    func recordButtonWasTapped() {
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
    
    func serviceButtonWasTapped() {
        self.navigationController?.pushViewController(MapViewController(), animated: true)
    }
    func resourcesButtonWasTapped() {
        self.navigationController?.pushViewController(ResourcesTableViewController(), animated: true)
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
        button.backgroundColor = .blue
        button.setTitle("Local Services", for: .normal)
        return button
        
    }()
    lazy var resourcesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Resouces", for: .normal)
        return button
        
    }()
    
}
