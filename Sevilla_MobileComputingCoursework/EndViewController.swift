//
//  EndViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 10/12/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    
    var score: String?
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func replayButton(_ sender: Any) {
    }
    
    @IBAction func scoresButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = score
        // Do any additional setup after loading the view.
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
