//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Yvan Pangilinan on 12/19/17.
//  Copyright © 2017 yvanpdev. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
    }
    
    //Record user audio and create a url path to be passed onto PlaySoundsViewController for voice modifications
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(flag: false, textLabel: "Recording in progress...")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordinngName = "recordedVoice.wav"
        let pathArray = [dirPath, recordinngName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //Stop audio recording, save audio session then navigate to UI view to play sounds view
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(flag: true, textLabel: "Tap to Record")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Initial setup for buttons and label.
    func configureUI(flag: Bool, textLabel: String){
        if flag {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        } else {
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }
        recordingLabel.text = textLabel
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    //Segue onto PlaySoundsViewController when function stopRecording is called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

