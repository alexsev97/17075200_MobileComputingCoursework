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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hsText.numberOfLines = 6
        print(highScores)
        
        hsText.text = "HIGHSCORES\n"
        var pos = 1
        
        for item in highScores{
            hsText.text?.append(String(pos) + ": " + String(item) + "\n")
            pos += 1
        }
        hsText.text?.popLast()
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
