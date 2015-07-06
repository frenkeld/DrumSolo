//
//  DrumViewController.swift
//  DrumSolo
//
//  Created by David Frenkel on 11/04/2015.
//  Copyright (c) 2015 David Frenkel. All rights reserved.
//

//TODO: Make sure to gather averages for base acceloration to make device agnostic


import UIKit
import AudioToolbox
import CoreMotion

class DrumViewController: UIViewController {
    
    //MARK: - Global Variables - Motion manager and effect preset
    let manager = CMMotionManager()
    var effectName = ""

    //MARK: - Ovverides - viewDidLoad and didRevicveMemWar
    override func viewDidLoad() {
        super.viewDidLoad()
        //effectName preset to effect numberOne
        self.setDrumsToOne(self)
        startDrumming()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Drumming
    
    func startDrumming() {
        
        //present valute for stabilizing movement checj
        var limiter = true
        var counter = 0;
        
        println("Running") //make popup!
        
        // check if motion is avilable - start motion update at high intervale
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.001
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                
                //pure accelariton date into double
                let z = data.userAcceleration.z - data.gravity.z
                
                //if accelaration is happening
                if z >= 1.08 || z <= -1 {
                    if limiter {
                        //if hit registerd sound is played - limiter false, counter reset
                        self!.playEffect()
                        limiter = false
                        counter = 0
                    }
                } // end of if
                
                //check if phone stopped "shakeing"
                if z <= 1.1 && z >= -1 && counter >= 15 {
                    limiter = true //limiter true --> stopped shakeing
                    //set background color back to white
                    self!.view.backgroundColor = UIColor.whiteColor()
                } // end of if
                counter++
            } //mainQ
        } // deviceMotion availve if end
    }
    
    
    
    func playEffect() {
        //find effect
        let path = NSBundle.mainBundle().pathForResource(effectName, ofType:"mp3")
        let url  = NSURL.fileURLWithPath(path!)
        
        //create effect
        var audioEffect = SystemSoundID()
        AudioServicesCreateSystemSoundID(url, &audioEffect)
        AudioServicesPlaySystemSound(audioEffect)
        //Beep background color to blue
        self.view.backgroundColor = UIColor.blueColor()
    }
    
    
    
    //MARK: - Change Drums --> Connection to StoryBoard
    @IBAction func setDrumsToOne(sender: AnyObject) {
        effectName = "effect"
    }
    @IBAction func setDrumsToTwo(sender: AnyObject) {
        effectName = "effect2"
    }
    @IBAction func setDrumsToThree(sender: AnyObject) {
        effectName = "effect3"
    }

    

}
