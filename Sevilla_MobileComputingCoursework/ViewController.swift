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
    @IBOutlet weak var background1View: UIImageView!
    @IBOutlet weak var background2View: UIImageView!
    @IBOutlet weak var background3View: UIImageView!
    @IBOutlet weak var cloud1View: UIImageView!
    @IBOutlet weak var cloud2View: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(background1View)
        self.view.addSubview(background2View)
        self.view.addSubview(background3View)
        self.view.addSubview(groundView)
        self.view.addSubview(cloud1View)
        self.view.addSubview(cloud2View)
        
        self.move(self.background1View, duration: 15, translation: -528)
        self.move(self.background2View, duration: 15, translation: -528)
        self.move(self.background3View, duration: 15, translation: -528)
        
        self.move(self.groundView, duration: 0.3, translation: -37)
        
         self.move(self.cloud1View, duration: 23, translation: -150)
        self.move(self.cloud2View, duration: 23, translation: -500)
        
    }
        
    func move(_ image: UIImageView, duration: Double, translation: CGFloat) {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: translation, y: 0)
            }) { (success: Bool) in
                image.transform = CGAffineTransform.identity
                self.move(image, duration: duration, translation: translation)
            }
        }


}
