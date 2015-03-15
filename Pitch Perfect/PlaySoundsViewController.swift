//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joshua Gan on 11/03/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioEchoPlayer:AVAudioPlayer!
    var reverbPlayers:[AVAudioPlayer] = []
    
    var receivedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    let N:Int = 10
    
    var reverbRun: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Audio Player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // Init Echo Player
        audioEchoPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioEchoPlayer.enableRate = true
        
        // Init Reverb Player
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl,
                error: nil)
            reverbPlayers.append(temp)
        }
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAndResetAllAudio()
        
        // Set rate to decrease playback speed
        audioPlayer.rate = 0.5
        
        audioPlayer.play()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        stopAndResetAllAudio()
        
        // Set rate to increase playback speed
        audioPlayer.rate = 1.5
        
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    

    
    func stopAndResetAllAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.0
        audioEchoPlayer.stop()
        audioEchoPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        
        // If reverb has been run then stop all reverb players
        if (reverbRun) {
            for i in 0...N {
                var player:AVAudioPlayer = reverbPlayers[i]
                player.stop()
                player.currentTime = 0.0
            }
            // Reset reverb run
            reverbRun = false
        }
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAndResetAllAudio()
        
        audioPlayer.play()
        
        // Setup echo 200ms
        let delay:NSTimeInterval = 0.2
        var playtime:NSTimeInterval
        playtime = audioEchoPlayer.deviceCurrentTime + delay
        audioEchoPlayer.stop()
        audioEchoPlayer.currentTime = 0
        audioEchoPlayer.volume = 0.8;
        audioEchoPlayer.playAtTime(playtime)
        
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAndResetAllAudio()
        
        reverbRun = true
        
        // 20ms produces detectable delays
        let delay:NSTimeInterval = 0.02
        for i in 0...N {
            var curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            //M_E is e=2.718...
            //dividing N by 2 made it sound ok for the case N=10
            var exponent:Double = -Double(i)/Double(N/2)
            var volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime + curDelay)
        }
        
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAndResetAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAllAudio()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
