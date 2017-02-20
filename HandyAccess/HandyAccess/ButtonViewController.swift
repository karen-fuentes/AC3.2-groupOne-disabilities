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
    
    var textSpoken = String()
    let boroughArray = ["Queens", "Brooklyn", "Bronx", "Staten Island", "Manhattan", "All"]

    class MyCustomPointAnnotation: MGLPointAnnotation {
        var willUseImage: Bool = false
    }
    var wheelMapLocationsArr = [WheelMapLocations]()
    let data = [WheelMapLocations]()
    var effect: UIVisualEffect!

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
    
    func speachButtonPressed() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
        } else {
            try! startRecording()
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
        
        boroughContainer.addSubview(resourceLabel)
        boroughContainer.addSubview(housingButton)
        boroughContainer.addSubview(healthButton)
        boroughContainer.addSubview(educationButton)
        boroughContainer.addSubview(employmentButton)
        boroughContainer.addSubview(artsCultureButton)
        boroughContainer.addSubview(disabilitiesButton)
        
        speechOrButtonContainer.addSubview(speechOrClickLabel)
        speechOrButtonContainer.addSubview(speechButtonForContainer)
        speechOrButtonContainer.addSubview(clickButtonsForContainer)

        view.addSubview(speechButton)
    }
    
    func setupView() {
        blur.snp.makeConstraints({ (view) in
            view.top.bottom.trailing.leading.equalToSuperview()
        })
        
        speechAndButtonContainer()
        boroughContrainer()
    }
    
    func buttonPressed(button: UIButton) {
        switch button {
//        case speechButtonForContainer:
//            print("Speech Button pressed")
        case clickButtonsForContainer:
            print("Want buttons")
            fadeOutView(view: speechOrButtonContainer, hidden: true)
            fadeInView(view: boroughContainer, hidden: true)
        default:
            break
        }
    }
    
    func boroughContrainer() {
        boroughContainer.snp.makeConstraints({ (view) in
            view.center.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.8)
            view.width.equalToSuperview().multipliedBy(0.9)
        })
        boroughContainer.isHidden = true
        
        boroughLabel.snp.makeConstraints({ (view) in
            view.top.equalTo(boroughContainer.snp.top).offset(20)
            view.centerX.equalTo(boroughContainer.snp.centerX)
        })
        
        queensButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(boroughLabel.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        brooklynButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(queensButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        bronxButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(brooklynButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        statenIslandButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(boroughLabel.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        manhattanButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(statenIslandButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        allButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(manhattanButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        resourceLabel.snp.makeConstraints({ (view) in
            view.top.equalTo(allButton.snp.bottom).offset(20)
            view.centerX.equalTo(boroughContainer.snp.centerX)
        })
        
        employmentButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(resourceLabel.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        disabilitiesButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(employmentButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        housingButton.snp.makeConstraints({ (view) in
            view.leading.equalTo(boroughContainer.snp.leading).offset(20)
            view.top.equalTo(disabilitiesButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        educationButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(resourceLabel.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        artsCultureButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(educationButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
        })
        
        healthButton.snp.makeConstraints({ (view) in
            view.trailing.equalTo(boroughContainer.snp.trailing).inset(20)
            view.top.equalTo(artsCultureButton.snp.bottom).offset(20)
            view.width.equalTo(boroughContainer.snp.width).multipliedBy(0.4)
            view.height.equalTo(45)
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
        
        clickButtonsForContainer.snp.makeConstraints({ (view) in
            view.top.equalTo(speechOrClickLabel.snp.bottom).offset(20)
            view.width.equalTo(speechOrButtonContainer.snp.width).multipliedBy(0.8)
            view.centerX.equalTo(speechOrButtonContainer.snp.centerX)
            view.height.equalTo(45)
        })
        
        speechButtonForContainer.snp.makeConstraints({ (view) in
            view.top.equalTo(clickButtonsForContainer.snp.bottom).offset(20)
            view.width.equalTo(speechOrButtonContainer.snp.width).multipliedBy(0.8)
            view.centerX.equalTo(speechOrButtonContainer.snp.centerX)
            view.height.equalTo(45)
        })
    }
    
//    func buttonPressed(button: UIButton) {
//        
//
//        //baseendpoint
//        //var endpoint = "http://wheelmap.org/api/categories/\(categoryNum)/node_types?&per_page=6"
//        let c = self.mapView!.getmapbounds() as MGLCoordinateBounds
//        
//        var endpoint = "http://wheelmap.org/en/api/nodes/search?q=\(categoryName)&bbox=\(c.ne.longitude),\(c.ne.latitude),\(c.sw.longitude),\(c.sw.latitude)&per_page=10"
//        print(endpoint)
//        
//        //make api call with endpoint
//        //update an array for objects
//        WheelMapManager.manager.getData(endpoint: endpoint) {(allData: [WheelMapLocations]?) in
//            //guard let allData = allData else {return}
//            
//            if allData != nil {
//                self.mapView!.refresh(object1: (allData)!)
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                print("None There")
//            }
//            
//            
//            
//
////            dump(allData)
////            DispatchQueue.main.async {
////                MapViewController().reloadInputViews()
////            }
//            
//        }
//        //dismiss after
//        //dismiss(animated: true, completion: nil)
//    }

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
        //view.backgroundColor = UIColor.brown
        return view
    }()
    
    internal lazy var speechOrClickLabel: UILabel = {
        let label = UILabel()
        label.text = "How would you like to navigate?"
        return label
    }()
    
    internal lazy var speechButtonForContainer: UIButton = {
        let button = UIButton()
        button.setTitle("Sound", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var clickButtonsForContainer: UIButton = {
        let button = UIButton()
        button.setTitle("Sight", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var boroughContainer: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.brown
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
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var brooklynButton: UIButton = {
        let button = UIButton()
        button.setTitle("Brooklyn", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var bronxButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bronx", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
//        button.backgroundColor?.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var statenIslandButton: UIButton = {
        let button = UIButton()
        button.setTitle("Staten Island", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var manhattanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Manhattan", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var resourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Resource..."
        return label
    }()
    
    internal lazy var housingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var healthButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var educationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var employmentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var artsCultureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var disabilitiesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Housing", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    internal lazy var blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        var blurEffectView = UIVisualEffectView(effect: blur)
        return blurEffectView
    }()
}
