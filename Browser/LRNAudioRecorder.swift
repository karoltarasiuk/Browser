//
//  LRNAudioRecorder.swift
//  Browser
//
//  Created by Jack Vo on 13/02/2015.
//  Copyright (c) 2015 Karol Tarasiuk. All rights reserved.
//

import UIKit
import AVFoundation
class LRNAudioRecorder: UIView {
    
    let RECORD_SETTING = [
        AVFormatIDKey: kAudioFormatAppleLossless,
        AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey: 320000,
        AVNumberOfChannelsKey: 1,
        AVSampleRateKey: 44100.0
    ]

    
    // Non-UI Component
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var meterTimer:NSTimer!
    var soundFileURL:NSURL?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var seekSlider: UISlider!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var currentFileName:String = ""
    
    // ------------------
    // Public methods
    // ------------------
    
    func initialize() {
        println("***LRNAudioRecorder initialize()")
        setSessionPlayback()
        setupNotifications()
    }
    
    func setupRecorder(fileName: String) -> Bool {
        println("***LRNAudioRecorder setupRecorder(\(fileName))")
        
        //Generate soundFileUrl to record
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docsDir: AnyObject = dirPaths[0]
        var soundFilePath = docsDir.stringByAppendingPathComponent(fileName);
        self.soundFileURL = NSURL(fileURLWithPath: soundFilePath)

        // Do we need this
//        var format = NSDateFormatter()
//        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
//        var currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        //---------------
        
        currentFileName = "" + fileName

        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(soundFilePath) {
            // probably won't happen. want to do something about it?
            println("sound exists")
        }
        
        //Initialize the audio recorder
        var error: NSError?
        recorder = AVAudioRecorder(URL: soundFileURL!, settings: RECORD_SETTING, error: &error)
        
        
        //Disable certain button
        self.stopButton.enabled = false
        self.playButton.enabled = false
        self.pauseButton.enabled = false
        self.seekSlider.enabled = false
        
        if let e = error {
            println("Failed to initialized recorder \(e.localizedDescription)")

        } else {
            recorder.delegate = self;
            recorder.meteringEnabled = true
            recorder.prepareToRecord()
        }
        
        return true
    }
    
    func destroy () {
        if recorder != nil {
            if recorder.recording {
                recorder.stop()
            }
            
            recorder = nil
            
            if let pl = player {
                player.stop()
                player = nil
            }
            
        }
    }
    
    func recordWithPermission(permission:Bool) {
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        //ios 8 and later
        if session.respondsToSelector("requestRecordPermission:") {
            AVAudioSession.sharedInstance().requestRecordPermission(
            { (granted: Bool) -> Void in
                if granted {
                    println("Has permission to record")
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(
                        0.1,
                        target: self,
                        selector: "updateAudioMeter:",
                        userInfo: nil,
                        repeats: true)
                } else {
                    println("NO permission to record")
                }
            })
        } else {
            println("requestRecordPermission unrecognized")
        }
    }
    
    func updateAudioMeter(timer:NSTimer) {
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let s = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            self.statusLabel.text = s
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
            var peak0 = recorder.peakPowerForChannel(0)
        }
    }
    
    // -------------------
    // UI Handlers
    // -------------------
    @IBAction func performRecord(sender:UIButton) {
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            println("Start to perform recording")
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            
            return
        }
        
        if recorder != nil && recorder.recording {
            println("Recorder is recording")
            performPauseRecording(nil)
        } else {
            println("Recorder is pausing")
            recordButton.setTitle("Pause", forState: UIControlState.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(false)
        }
    }
    
    @IBAction func performPauseRecording(sender:UIButton?) {
        if recorder != nil && recorder.recording {
            recordButton.setTitle("Continue recording", forState: UIControlState.Normal)
            recorder.pause()
        }
    }
    
    @IBAction func playback() {
        println("playing")
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        self.player = AVAudioPlayer(contentsOfURL: soundFileURL!, error: &error)
        if player == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        player.delegate = self
        player.prepareToPlay()
        player.volume = 1.0
        player.play()
    }
    
    @IBAction func stop(sender: UIButton) {
        println("stop")
        recorder.stop()
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", forState:.Normal)
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setActive(false, error: &error) {
            println("could not make session inactive")
            if let e = error {
                println(e.localizedDescription)
                return
            }
        }
        playButton.enabled = true
        stopButton.enabled = false
        recordButton.enabled = true
        //recorder = nil
    }
    
    // -------------------
    // Initialize phase
    // -------------------
    private func setSessionPlayback() {
        println("***LRNAudioRecorder setSessionPlayback()")
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        
        if !session.setCategory(AVAudioSessionCategoryPlayback,
            error: &error) {
                println("Could not set session Category")
                
                if let e = error {
                    println(e.localizedDescription)
                }
        }
        if !session.setActive(true, error: &error) {
            println("Could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    private func setupNotifications() {
        println("***LRNAudioRecorder setupNotifications()")
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onAppInBackground",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onAppInForeground",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onRecorderRouteChange",
            name: AVAudioSessionRouteChangeNotification,
            object: nil)
    }
    
    
    // Notification
    func onAppInBackground(notification:NSNotification) {
        //Pause the recording if app is in background
        println("App is in background")
    }
    
    func onAppInForeground(notification:NSNotification) {
        //Resume the recording if required
        println("App is in Foreground")
    }
    
    func onRecorderRouteChange(notification:NSNotification) {
        println("Recorder's Route has changed")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
}


extension LRNAudioRecorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("Recorder has finished recording \(flag)")
        stopButton.enabled = false
        playButton.enabled = true
        

        
//        var alert = UIAlertController(
//            title: "Information",
//            message: "Finished recording",
//            preferredStyle: .Alert)
//        
//        alert.addAction(UIAlertAction(
//            title: "", style: .Default,
//            handler: nil))
//        alert.show
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Recorder \(error.localizedDescription)")
    }
}

extension LRNAudioRecorder: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("Player has finished playing \(flag)")
        recordButton.enabled = true;
        stopButton.enabled = false;
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Player failed to decode \(error.localizedDescription)")
    }
}