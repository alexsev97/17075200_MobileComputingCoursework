//
//  EndViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 10/12/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit
import AVFoundation

class EndViewController: UIViewController {
    
    var score: Int = 0
    var highScoreArray : [Int] = []
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var congratulationsLabel: UILabel!
    
    
    var endMusic: AVAudioPlayer?
    var endMusicPath: String?
    var endMusicUrl: URL?
    
    
    @IBAction func replayButton(_ sender: Any) {
        // Dismiss view
        self.dismiss(animated: true, completion: nil)
        // Stop playing music because the game has its own
        self.endMusic?.stop()
    }
    
    @IBAction func scoresButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("appear!")
        scoreLabel.text = "Score: " + String(score)
        // Play music
        endMusicPath = Bundle.main.path(forResource:"endGameSong.mp3", ofType: nil)!
        endMusicUrl = URL(fileURLWithPath: endMusicPath!)
         do{
            self.endMusic = try AVAudioPlayer(contentsOf: self.endMusicUrl!)
            self.endMusic?.play()
            self.endMusic?.volume = 0.6
            self.endMusic?.numberOfLoops = -1
         }
         catch{
            print("Couldn't load audio file")
        }
        
        // Load high scores
        let highScoreDefault = UserDefaults.init()
        if (highScoreDefault.array(forKey: "highscore") != nil){
            highScoreArray = highScoreDefault.array(forKey: "highscore") as! [Int]
        }
        // Insert the new score in the vectore (if it is a high score)
        highScoreArray.insert(score, at: highScoreArray.index(where: {$0 < score}) ?? highScoreArray.endIndex)
        // If there is less then 5, it is always going to be a high score
        if (highScoreArray.count <= 5){
            congratulationsLabel.text = "NEW RECORD!"
        }
        else{
            // We take out the last element of the vector (so that there's always 5)
            // If the last element doesn't match the score by the player, it's a high score
            if (highScoreArray.popLast() != score){
                congratulationsLabel.text = "NEW RECORD!"
            }
        }
        // We store the new vector in the memory
        highScoreDefault.set(highScoreArray, forKey: "highscore")
        // Uncomment this line to reset the high score array
       // highScoreDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        highScoreDefault.synchronize()
    }

}
