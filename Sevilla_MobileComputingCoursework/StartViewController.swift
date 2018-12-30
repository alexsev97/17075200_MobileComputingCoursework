//
//  StartViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 27/12/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit
import AVFoundation

// View Controller of menu screen
class StartViewController: UIViewController {
    
    var startMusic: AVAudioPlayer?
    var startMusicPath: String?
    var startMusicUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Play music
        startMusicPath = Bundle.main.path(forResource:"endGameSong.mp3", ofType: nil)!
        startMusicUrl = URL(fileURLWithPath: startMusicPath!)
        do{
            self.startMusic = try AVAudioPlayer(contentsOf: self.startMusicUrl!)
            self.startMusic?.play()
            self.startMusic?.volume = 0.6
            self.startMusic?.numberOfLoops = -1
        }
        catch{
            print("Couldn't load audio file")
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Stop playing music when advancing to the game because it has its own
        if (segue.identifier == "startSegue"){
             self.startMusic?.stop()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
