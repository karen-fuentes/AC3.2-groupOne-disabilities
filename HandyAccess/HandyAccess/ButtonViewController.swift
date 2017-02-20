//
//  ButtonViewController.swift
//  HandyAccess
//
//  Created by Edward Anchundia on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import SnapKit
import Speech

class ButtonViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var textSpoken = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        setupView()
        
        speechButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechButton.isEnabled = true
                case .denied:
                    self.speechButton.isEnabled = false
                    self.speechButton.setTitle("User denied access to speech recognition", for: .disabled)
                case .restricted:
                    self.speechButton.isEnabled = false
                    self.speechButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                case .notDetermined:
                    self.speechButton.isEnabled = false
                    self.speechButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
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
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textSpoken = result.bestTranscription.formattedString
                print("Speech: \(result.bestTranscription.formattedString)")
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
//        textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechButton.isEnabled = true
        } else {
            speechButton.isEnabled = false
        }
    }
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        view.addSubview(blur)
        view.addSubview(boroughContainer)
        view.addSubview(speechOrButtonContainer)
        
        boroughContainer.addSubview(boroughLabel)
        boroughContainer.addSubview(queensButton)
        boroughContainer.addSubview(brooklynButton)
        boroughContainer.addSubview(bronxButton)
        boroughContainer.addSubview(statenIslandButton)
        boroughContainer.addSubview(manhattanButton)
        boroughContainer.addSubview(allButton)
        
        speechOrButtonContainer.addSubview(speechOrClickLabel)
        speechOrButtonContainer.addSubview(speechButtonForContainer)
        speechButtonForContainer.addSubview(clickButtonsForContainer)
//        view.addSubview(button1)
//        view.addSubview(button2)
//        view.addSubview(button3)
//        view.addSubview(button4)
//        view.addSubview(button5)
        boroughContainer.addSubview(speechButton)
    }
    
    func setupView() {
        blur.snp.makeConstraints({ (view) in
            view.top.bottom.trailing.leading.equalToSuperview()
        })
        
        speechAndButtonContainer()
        boroughContrainer()
        
        
//        button1.snp.makeConstraints({ (view) in
//            view.top.equalToSuperview().offset(50)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.5)
//            view.height.equalTo(70)
//        })
//        
//        button2.snp.makeConstraints({ (view) in
//            view.top.equalTo(button1.snp.bottom).offset(30)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.5)
//            view.height.equalTo(70)
//        })
//        
//        button3.snp.makeConstraints({ (view) in
//            view.top.equalTo(button2.snp.bottom).offset(30)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.5)
//            view.height.equalTo(70)
//        })
//        
//        button4.snp.makeConstraints({ (view) in
//            view.top.equalTo(button3.snp.bottom).offset(30)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.5)
//            view.height.equalTo(70)
//        })
//        
//        button5.snp.makeConstraints({ (view) in
//            view.top.equalTo(button4.snp.bottom).offset(30)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.5)
//            view.height.equalTo(70)
//        })
        
//        speechButton.snp.makeConstraints({ (view) in
//            view.top.equalTo(button5.snp.bottom).offset(30)
//            view.centerX.equalToSuperview()
//            view.width.equalToSuperview().multipliedBy(0.2)
//            view.height.equalTo(70)
//        })
    }
    
    func buttonPressed(button: UIButton) {
//        if button == button1 {
//            print("button 1")
//            dismiss(animated: true, completion: nil)
//        } else if button == button2 {
//            print("button 2")
//            dismiss(animated: true, completion: nil)
//        } else if button == button3 {
//            print("button 3")
//            dismiss(animated: true, completion: nil)
//        } else if button == button4 {
//            print("button 4")
//            dismiss(animated: true, completion: nil)
//        } else if button == button5 {
//            print("button 5")
//            dismiss(animated: true, completion: nil)
//        }
        
        if button == speechButtonForContainer {
            print("Speech Button pressed")
            fadeOutView(view: speechOrButtonContainer, hidden: true)
            fadeInView(view: boroughContainer, hidden: true)
        } else if button == clickButtonsForContainer {
            print("Want buttons")
            fadeOutView(view: speechOrButtonContainer, hidden: true)
        }
    }
    
    func speachButtonPressed() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
        } else {
            try! startRecording()
        }
    }

//    internal lazy var button1: UIButton = {
//        let button = UIButton()
//        button.setTitle("button", for: .normal)
//        button.backgroundColor = UIColor.gray
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    internal lazy var button2: UIButton = {
//        let button = UIButton()
//        button.setTitle("button", for: .normal)
//        button.backgroundColor = UIColor.gray
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    internal lazy var button3: UIButton = {
//        let button = UIButton()
//        button.setTitle("button", for: .normal)
//        button.backgroundColor = UIColor.gray
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    internal lazy var button4: UIButton = {
//        let button = UIButton()
//        button.setTitle("button", for: .normal)
//        button.backgroundColor = UIColor.gray
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    internal lazy var button5: UIButton = {
//        let button = UIButton()
//        button.setTitle("button", for: .normal)
//        button.backgroundColor = UIColor.gray
////        button.backgroundColor?.withAlphaComponent(0.5)
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
    
    func boroughContrainer() {
        boroughContainer.snp.makeConstraints({ (view) in
            view.center.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.8)
            view.width.equalToSuperview().multipliedBy(0.8)
        })
        boroughContainer.isHidden = true
        
        boroughLabel.snp.makeConstraints({ (view) in
            view.top.equalTo(boroughContainer.snp.top).offset(20)
            view.centerX.equalTo(boroughContainer.snp.centerX)
        })
        
        queensButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(boroughLabel.snp.bottom).offset(20)
        })
        
        brooklynButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(queensButton.snp.bottom).offset(20)
        })
        
        bronxButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(brooklynButton.snp.bottom).offset(20)
        })
        
        statenIslandButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(boroughLabel.snp.bottom).offset(20)
        })
        
        manhattanButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(statenIslandButton.snp.bottom).offset(20)
        })
        
        allButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(manhattanButton.snp.bottom).offset(20)
        })
        
        speechButton.snp.makeConstraints({ (view) in
            view.top.equalTo(allButton.snp.bottom).offset(30)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.2)
            view.height.equalTo(70)
        })
    }
    
    func speechAndButtonContainer() {
        speechOrButtonContainer.snp.makeConstraints({ (view) in
            view.center.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.3)
            view.width.equalToSuperview().multipliedBy(0.8)
        })
        
        speechOrClickLabel.snp.makeConstraints({ (view) in
            view.top.equalTo(speechOrButtonContainer.snp.top).offset(20)
            view.centerX.equalTo(speechOrButtonContainer.snp.centerX)
        })
        
        speechButtonForContainer.snp.makeConstraints({ (view) in
            view.top.equalTo(speechOrClickLabel.snp.bottom).offset(20)
            view.leading.equalTo(speechOrButtonContainer.snp.leading).offset(20)
        })
        
        clickButtonsForContainer.snp.makeConstraints({ (view) in
            view.top.equalTo(speechOrClickLabel.snp.bottom).offset(20)
            view.trailing.equalTo(speechOrButtonContainer.snp.trailing).inset(20)
        })
    }
    
    func fadeOutView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
            view.isHidden = true
        }, completion: { _ in })
    }
    
    func fadeInView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
            view.isHidden = false
        }, completion: { _ in })
    }
    
    internal lazy var speechButton: UIButton = {
        let button = UIButton()
        button.setTitle("Speak", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(speachButtonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var speechOrButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown
        return view
    }()
    
    internal lazy var speechOrClickLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Speech or Clicks"

        return label
    }()
    
    internal lazy var speechButtonForContainer: UIButton = {
        let button = UIButton()
        button.setTitle("Speech", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var clickButtonsForContainer: UIButton = {
        let button = UIButton()
        button.setTitle("Click", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var boroughContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown
        return view
    }()
    
    internal lazy var boroughLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a borough..."
        return label
    }()
    
    internal lazy var queensButton: UIButton = {
        let button = UIButton()
        button.setTitle("Queens", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var brooklynButton: UIButton = {
        let button = UIButton()
        button.setTitle("Brooklyn", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var bronxButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bronx", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var statenIslandButton: UIButton = {
        let button = UIButton()
        button.setTitle("Staten Island", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var manhattanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Manhattan", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        var blurEffectView = UIVisualEffectView(effect: blur)
        return blurEffectView
    }()
}
