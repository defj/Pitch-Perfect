//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joshua Gan on 9/03/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    var paused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Show tap to record message
        recordingInProgress.text = "Tap to record"
        
        // Enable record button
        recordBtn.enabled = true
        
        // Hide pause and resume buttons
        stopRecording.hidden = true
        pauseBtn.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {

        // Disable record button
        recordBtn.enabled = false
        
        // Show recording message
        recordingInProgress.text = "Recording in progress"
        
        // Show Stop Button
        stopRecording.hidden = false
        
        // Show Pause Button
        pauseBtn.hidden = false
        
        // Setup Audio Recording
        if (!paused) {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
        
            // Setup Audio Session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            // Init recorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
        }
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        
        paused = true
        
        // Enable record button and change display message
        recordBtn.enabled = true
        recordingInProgress.text = "Tap to resume recording"
        
        // Hide stop and pause buttons
        stopRecording.hidden = true
        pauseBtn.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordBtn.enabled = true
            stopRecording.hidden = true
            pauseBtn.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        println("in stopAudio")
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

