//
//  ViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 04/11/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

protocol subviewDelegate {
    func beginDrag()
    func endDrag()
    func checkCollision() -> Bool
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
    var imageArray: [UIImage]!
    var draggedImageArray: [UIImage]!
    
    // Enemy character images
    var koopaView = UIImageView(image: nil)
    var koopaImageArray: [UIImage]!
    
    // Behavior items
    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(background1View)
        self.view.addSubview(background2View)
        self.view.addSubview(background3View)
        self.view.addSubview(groundView)
        self.view.addSubview(cloud1View)
        self.view.addSubview(cloud2View)
        self.view.addSubview(marioView)
        marioView.myDelegate = self
        
        self.moveInLoop(self.background1View, duration: 15, translation: -528)
        self.moveInLoop(self.background2View, duration: 15, translation: -528)
        self.moveInLoop(self.background3View, duration: 15, translation: -528)
        
        self.moveInLoop(self.groundView, duration: 0.3, translation: -37)
        
        self.moveInLoop(self.cloud1View, duration: 23, translation: -150)
        self.moveInLoop(self.cloud2View, duration: 23, translation: -500)
        
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        gravityBehavior = UIGravityBehavior(items: [marioView])
        dynamicAnimator.addBehavior(gravityBehavior)
        gravityBehavior.magnitude = 0.3
        
        collisionBehavior = UICollisionBehavior(items: [marioView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        collisionBehavior.addBoundary(withIdentifier: "barrier" as
            NSCopying, for: UIBezierPath(rect: groundView.frame))
        
       
        imageArray = [UIImage(named: "mario1.png")!,UIImage(named:"mario2.png")!,UIImage(named:"mario3.png")! ]
        draggedImageArray = [UIImage(named: "dmario1.png")!,UIImage(named:"dmario2.png")!,UIImage(named:"dmario3.png")! ]
        marioView.image = UIImage.animatedImage(with: imageArray, duration: 0.4)
        
        
        koopaImageArray = [UIImage(named: "wingkoopa1.png")!,UIImage(named:"wingkoopa2.png")!,UIImage(named:"wingkoopa3.png")!,UIImage(named:"wingkoopa4.png")!,UIImage(named:"wingkoopa5.png")! ]
        koopaView.image = UIImage.animatedImage(with: koopaImageArray, duration: 0.6)
        
        koopaView.frame = CGRect(x:UIScreen.main.bounds.width + 60, y: 200, width: 60, height: 60)
        self.view.addSubview(koopaView)
        self.moveAndDestroy(koopaView, duration: 7)
        generateEnemy()
        
        let endGame = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: endGame) {
            print("The game has ended")
        }
    }
    
    func moveInLoop(_ image: UIImageView, duration: Double, translation: CGFloat) {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: translation, y: 0)
            }) { (success: Bool) in
                image.transform = CGAffineTransform.identity
                self.moveInLoop(image, duration: duration, translation: translation)
            }
        }
    
    func moveAndDestroy(_ image: UIImageView, duration: Double) {
        let translation = -UIScreen.main.bounds.width - 2 * image.frame.width
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(translationX: translation, y: 0)
        }) { (success: Bool) in
            image.transform = CGAffineTransform.identity
           image.removeFromSuperview()
        }
    }
    
    func generateEnemy(){
        let newEnemy = UIImageView(image: nil)
        newEnemy.image = UIImage.animatedImage(with: koopaImageArray, duration: 0.6)
        let yc = Int.random(in: 60 ..< 300)
        newEnemy.frame = CGRect(x:Int(UIScreen.main.bounds.width + newEnemy.frame.width), y: yc, width: 60, height: 60)
        self.view.addSubview(newEnemy)
        self.moveAndDestroy(newEnemy, duration: 7)
        let enemyDelay =  DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: enemyDelay) {
            self.generateEnemy()
        }
    }
    
  /*  func generatePositiveRandomValue (lower: UInt32, upper: UInt32) -> UInt32 {
        var diff: UInt32
        diff = upper - lower
        var rads: UInt32
        rads = arc4random_uniform((diff + 1) * 2) - diff
        if (rads <= 0) {
            rads = rads - lower
        } else {
            rads = rads + lower - 1
        }
        return rads
    }
    */
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
    func beginDrag() {
        marioView.image = UIImage.animatedImage(with: draggedImageArray, duration: 0.4)
        gravityBehavior.removeItem(marioView)
        collisionBehavior.removeItem(marioView)
    }
    
    func endDrag() {
        marioView.image = UIImage.animatedImage(with: imageArray, duration: 0.4)
        gravityBehavior.addItem(marioView)
        collisionBehavior.addItem(marioView)
    }
    
    func checkCollision() -> Bool {
        if (marioView.frame.intersects(groundView.frame)){
            return true
        }
        return false
        
    }

}
