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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scoresButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("appear!")
        scoreLabel.text = "Score: " + String(score)
        
        endMusicPath = Bundle.main.path(forResource:"endGameSong.mp3", ofType: nil)!
        endMusicUrl = URL(fileURLWithPath: endMusicPath!)
         do{
            self.endMusic = try AVAudioPlayer(contentsOf: self.endMusicUrl!)
            self.endMusic?.play()
            self.endMusic?.numberOfLoops = -1
         }
         catch{
            print("Couldn't load audio file")
        }
        
        let highScoreDefault = UserDefaults.init()
        if (highScoreDefault.array(forKey: "highscore") != nil){
            highScoreArray = highScoreDefault.array(forKey: "highscore") as! [Int]
        }
        highScoreArray.insert(score, at: highScoreArray.index(where: {$0 < score}) ?? highScoreArray.endIndex)
        if (highScoreArray.count <= 5){
            congratulationsLabel.text = "Highscore!"
        }
        else{
            if (highScoreArray.popLast() != score){
                congratulationsLabel.text = "Highscore!"
            }
        }
        highScoreDefault.set(highScoreArray, forKey: "highscore")
       // highScoreDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        highScoreDefault.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "highScoreSegue"){
            let hsViewController = segue.destination as! HighScoreViewController
            hsViewController.highScores = self.highScoreArray
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         self.endMusic?.stop()
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
