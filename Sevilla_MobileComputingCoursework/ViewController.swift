//
//  ViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 04/11/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

protocol subviewDelegate {
    func addGravity()
    func removeGravity()
}

class ViewController: UIViewController, subviewDelegate {
    // Moving background items
    @IBOutlet weak var groundView: UIImageView!
    @IBOutlet weak var background1View: UIImageView!
    @IBOutlet weak var background2View: UIImageView!
    @IBOutlet weak var background3View: UIImageView!
    @IBOutlet weak var cloud1View: UIImageView!
    @IBOutlet weak var cloud2View: UIImageView!
    
    // Main character items
    @IBOutlet weak var marioView: DraggedImageView!
    
    
    // Behavior items
    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(background1View)
        self.view.addSubview(background2View)
        self.view.addSubview(background3View)
        self.view.addSubview(groundView)
        self.view.addSubview(cloud1View)
        self.view.addSubview(cloud2View)
        self.view.addSubview(marioView)
        marioView.myDelegate = self
        
        self.move(self.background1View, duration: 15, translation: -528)
        self.move(self.background2View, duration: 15, translation: -528)
        self.move(self.background3View, duration: 15, translation: -528)
        
        self.move(self.groundView, duration: 0.3, translation: -37)
        
        self.move(self.cloud1View, duration: 23, translation: -150)
        self.move(self.cloud2View, duration: 23, translation: -500)
        
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        gravityBehavior = UIGravityBehavior(items: [])
        dynamicAnimator.addBehavior(gravityBehavior)
        gravityBehavior.magnitude = 0.3
        
        collisionBehavior = UICollisionBehavior(items: [marioView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        collisionBehavior.addBoundary(withIdentifier: "barrier" as
            NSCopying, for: UIBezierPath(rect: groundView.frame))

    }
        
    func move(_ image: UIImageView, duration: Double, translation: CGFloat) {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: translation, y: 0)
            }) { (success: Bool) in
                image.transform = CGAffineTransform.identity
                self.move(image, duration: duration, translation: translation)
            }
        }
    
   /* func panGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began.")
                if marioView.frame.contains(gesture.location(in: view)) {
                    gravityBehavior.removeItem(marioView)
            }
        case .changed:
            let translation = gesture.translation(in: marioView)
            
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
            
            gesture.setTranslation(CGPoint.zero, in: self.view)
            
            print("\(gesture.view!.center.x)=\(gesture.view!.center.y)")
            print("t;: \(translation)")
        case .ended:
                if marioView.frame.contains(gesture.location(in: view)) {
                    gravityBehavior.addItem(marioView)
            }
            print("Ended.")
        case .cancelled:
            print("Cancelled")
        default:
            print("Default")
        }
    }
    */
    func removeGravity() {
        gravityBehavior.removeItem(marioView)
        collisionBehavior.removeItem(marioView)
    }
    
    func addGravity() {
        gravityBehavior.addItem(marioView)
        collisionBehavior.addItem(marioView)
    }
}
