//
//  InitialViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/19/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//



import UIKit
import Speech
import SnapKit
import AVFoundation



class InitialViewController: UIViewController, SFSpeechRecognizerDelegate {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var isFinal = false
    var isAlreadyPushed = false
    //var searchTerm = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHiearchy()
        configureConstraints()
        recordButton.isEnabled = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        let synthesizer = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: "Tap the bottom of the bottom of the screen if you would like local services say local services for resources say resources")
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
            print("isFinal \(self.isFinal) after entering the speechRecognizer; suppose to be false")
            if let result = result {
                let results = result.bestTranscription.formattedString
                self.textView.text = result.bestTranscription.formattedString
                self.isFinal = result.isFinal
                print("\(self.isFinal) when do self.isFinal = result.isFinal")
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
            print("isFinal \(self.isFinal) after resetting record button to true, suppose to be true")
            
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
        //        self.view.addSubview(buttonContainer)
        //        self.buttonContainer.addSubview(resourcesButton)
        //        self.buttonContainer.addSubview(serviceButton)
    }
    
    func configureConstraints() {
        textView.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(50.0)
            
        }
        recordButton.snp.makeConstraints { (button) in
            button.leading.trailing.bottom.equalToSuperview()
            button.top.equalTo(textView.snp.bottom)
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
    lazy var buttonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
}
