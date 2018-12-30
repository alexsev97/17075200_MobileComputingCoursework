//
//  HighScoreViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 16/12/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    var highScores: [Int] = []
    @IBOutlet weak var hsText: UILabel!
    @IBAction func backButton(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load high scores
        let highScoreDefault = UserDefaults.init()
        if (highScoreDefault.array(forKey: "highscore") != nil){
            highScores = highScoreDefault.array(forKey: "highscore") as! [Int]
        }
        hsText.numberOfLines = 6
        
        hsText.text = "HIGHSCORES\n"
        var pos = 1
        // Configure the text label for the high scores
        for item in highScores{
            hsText.text?.append(String(pos) + ": " + String(item) + "\n")
            pos += 1
        }
        // Remove the last line break
        hsText.text?.popLast()
    }

}
