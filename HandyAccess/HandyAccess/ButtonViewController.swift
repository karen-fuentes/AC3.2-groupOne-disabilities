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
import Mapbox

class ButtonViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var mapView:MapViewController?

    public func setMapController(map1: MapViewController) {
        mapView = map1
    }
    
    class MyCustomPointAnnotation: MGLPointAnnotation {
        var willUseImage: Bool = false
    }
    var wheelMapLocationsArr = [WheelMapLocations]()

    
    var textSpoken = String()
    let data = [WheelMapLocations]()
    var effect: UIVisualEffect!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.black
//        view.alpha = 0.2
        
        effect = self.blur.effect
        blur.effect = self.effect
        
        //view.isOpaque = false
        setupViewHierarchy()
        setupView()
        
        speechButton.isEnabled = false
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: Selector("filterButtonBarButtonPressed"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        effect = self.blur.effect
        blur.effect = self.effect
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
    
    //private func filterButtonBarButtonPressed() {
    //    self.present(ButtonViewController(), animated: true, completion: nil)
    //}
    
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
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        view.addSubview(button6)
        view.addSubview(button7)
        view.addSubview(button8)
        view.addSubview(button9)
        view.addSubview(button10)
        view.addSubview(speechButton)
    }
    
    func setupView() {
        blur.snp.makeConstraints({ (view) in
            view.top.bottom.trailing.leading.equalToSuperview()
        })
        
        button1.snp.makeConstraints({ (view) in
            view.top.equalToSuperview().offset(50)
            view.leading.equalTo(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button2.snp.makeConstraints({ (view) in
            view.top.equalToSuperview().offset(50)
            view.trailing.equalToSuperview().inset(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button3.snp.makeConstraints({ (view) in
            view.top.equalTo(button1.snp.bottom).offset(30)
            view.leading.equalTo(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button4.snp.makeConstraints({ (view) in
            view.top.equalTo(button2.snp.bottom).offset(30)
            view.trailing.equalToSuperview().inset(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button5.snp.makeConstraints({ (view) in
            view.top.equalTo(button3.snp.bottom).offset(30)
            view.leading.equalTo(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button6.snp.makeConstraints({ (view) in
            view.top.equalTo(button4.snp.bottom).offset(30)
            view.trailing.equalToSuperview().inset(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button7.snp.makeConstraints({ (view) in
            view.top.equalTo(button5.snp.bottom).offset(30)
            view.leading.equalTo(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button8.snp.makeConstraints({ (view) in
            view.top.equalTo(button6.snp.bottom).offset(30)
            view.trailing.equalToSuperview().inset(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button9.snp.makeConstraints({ (view) in
            view.top.equalTo(button7.snp.bottom).offset(30)
            view.leading.equalTo(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        button10.snp.makeConstraints({ (view) in
            view.top.equalTo(button8.snp.bottom).offset(30)
            view.trailing.equalToSuperview().inset(20)
            view.width.equalToSuperview().multipliedBy(0.40)
            view.height.equalToSuperview().multipliedBy(0.1)
            //view.width.equalTo(150)
            //view.height.equalTo(70)
        })
        
        speechButton.snp.makeConstraints({ (view) in
            view.bottom.equalToSuperview().inset(60)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.2)
            view.height.equalToSuperview().multipliedBy(0.1)
        })
    }
    
    func buttonPressed(button: UIButton) {
        
        var categoryName = ""
        
        if button == button1 {
            print("button 1")
           categoryName = "food"
          
        } else if button == button2 {
            print("button 2")
            categoryName = "PublicTransport"
            
        } else if button == button3 {
            print("button 3")
            categoryName = "Health"
            
        } else if button == button4 {
            print("button 4")
            categoryName = "Government"
            
        } else if button == button5 {
            print("button 5")
            categoryName = "Bank/PostOffice"
            
        } else if button == button6 {
            print("button 6")
            categoryName = "Education"
            
        } else if button == button7 {
            print("button 7")
            categoryName = "Leisure"
            
        } else if button == button8 {
            print("button 8")
            categoryName = "food"
            
        } else if button == button9 {
            print("button 9")
            categoryName = "food"
            
        } else if button == button10 {
            print("button 10")
            categoryName = "food"
        }
        //baseendpoint
        //var endpoint = "http://wheelmap.org/api/categories/\(categoryNum)/node_types?&per_page=6"
        let c = self.mapView!.getmapbounds() as MGLCoordinateBounds
        
        var endpoint = "http://wheelmap.org/en/api/nodes/search?q=\(categoryName)&bbox=\(c.ne.longitude),\(c.ne.latitude),\(c.sw.longitude),\(c.sw.latitude)&per_page=10"
        print(endpoint)
        
        //make api call with endpoint
        //update an array for objects
        WheelMapManager.manager.getData(endpoint: endpoint) {(allData: [WheelMapLocations]?) in
            //guard let allData = allData else {return}
            DispatchQueue.main.async {
                if allData != nil {
                    self.mapView!.refresh(object1: (allData)!)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("None There")
                }
                
            }
            
            

//            dump(allData)
//            DispatchQueue.main.async {
//                MapViewController().reloadInputViews()
//            }
            
        }
        //dismiss after
        //dismiss(animated: true, completion: nil)
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

    internal lazy var button1: UIButton = {
        let button = UIButton()
        button.setTitle("Food", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button2: UIButton = {
        let button = UIButton()
        button.setTitle("Public Transport", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button3: UIButton = {
        let button = UIButton()
        button.setTitle("Health", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button4: UIButton = {
        let button = UIButton()
        button.setTitle("Government", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button5: UIButton = {
        let button = UIButton()
        button.setTitle("Bank/Post Office", for: .normal)
        button.backgroundColor = UIColor.gray
//        button.backgroundColor?.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button6: UIButton = {
        let button = UIButton()
        button.setTitle("Education", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button7: UIButton = {
        let button = UIButton()
        button.setTitle("Leisure", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button8: UIButton = {
        let button = UIButton()
        button.setTitle("Shopping", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button9: UIButton = {
        let button = UIButton()
        button.setTitle("Sport", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var button10: UIButton = {
        let button = UIButton()
        button.setTitle("Tourism", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var speechButton: UIButton = {
        let button = UIButton()
        button.setTitle("Speak", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(speachButtonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        var blurEffectView = UIVisualEffectView(effect: blur)
        return blurEffectView
    }()
}
