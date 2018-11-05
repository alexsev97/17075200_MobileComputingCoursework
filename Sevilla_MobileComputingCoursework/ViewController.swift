//
//  ViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 04/11/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var groundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.animate(self.groundView)

    }
        
        func animate(_ image: UIImageView) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: -37, y: 0)
            }) { (success: Bool) in
                image.transform = CGAffineTransform.identity
                self.animate(image)
            }
        }


}
