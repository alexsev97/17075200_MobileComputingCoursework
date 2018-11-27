//
//  ViewController.swift
//  Sevilla_MobileComputingCoursework
//
//  Created by Alejandro Sevilla Romero  on 04/11/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit
import AVFoundation

protocol subviewDelegate {
    func beginDrag()
    func endDrag()
    func checkCollision() -> Bool
    func updateBoundary()
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
    var dragging = false
    
    // Enemy character images
    var koopaImage: UIImage!
    var koopaImageArray: [UIImage]!
    var enemyArray: [UIImageView]!
    var shellImageArray: [UIImage]!
    
    // Sound effects
    var kickSoundEffect: AVAudioPlayer?
    
    // Text label containing the score
    @IBOutlet weak var scoreLabel: UITextField!
    var score = 0
    
    // Behavior items
    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    
    var enemyCollisionBehavior: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.view.addSubview(background1View)
        self.view.addSubview(background2View)
        self.view.addSubview(background3View)
        self.view.addSubview(groundView)
        self.view.addSubview(cloud1View)
        self.view.addSubview(cloud2View)
        self.view.addSubview(marioView)
        marioView.myDelegate = self
        self.view.addSubview(scoreLabel)
        
        self.moveInLoop(self.background1View, duration: 15, translation: -528)
        self.moveInLoop(self.background2View, duration: 15, translation: -528)
        self.moveInLoop(self.background3View, duration: 15, translation: -528)
        self.moveInLoop(self.groundView, duration: 0.3, translation: -37)
        self.moveInLoop(self.cloud1View, duration: 23, translation: -150)
        self.moveInLoop(self.cloud2View, duration: 23, translation: -500)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        gravityBehavior = UIGravityBehavior(items: [marioView])
        dynamicAnimator.addBehavior(gravityBehavior)
        gravityBehavior.magnitude = 0.4
        
        collisionBehavior = UICollisionBehavior(items: [marioView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        collisionBehavior.addBoundary(withIdentifier: "groundBound" as NSCopying, for: UIBezierPath(rect: groundView.frame))
        
        enemyCollisionBehavior = UICollisionBehavior.init()
        enemyCollisionBehavior.collisionMode = UICollisionBehavior.Mode.boundaries
        enemyCollisionBehavior.translatesReferenceBoundsIntoBoundary = false
        dynamicAnimator.addBehavior(enemyCollisionBehavior)
        enemyCollisionBehavior.addBoundary(withIdentifier: "marioBound" as NSCopying, for: UIBezierPath(rect: marioView.frame))
        
        enemyCollisionBehavior.action = {
            for item in self.enemyArray{
                if(item.frame.intersects(self.marioView.frame)) {
                    self.score -= 5
                    self.updateScore()
                    self.dynamicItemBehavior.removeItem(item)
                    self.enemyCollisionBehavior.removeItem(item)
                    let oldFrame = item.frame
                    item.removeFromSuperview()
                    item.frame = CGRect.zero
                    self.marioView.image = UIImage(named: "hitMario.png")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        if (self.dragging){
                            self.marioView.image = UIImage.animatedImage(with: self.draggedImageArray, duration: 0.4)
                        }
                        else{
                            self.marioView.image = UIImage.animatedImage(with: self.imageArray, duration: 0.4)
                        }
                    }
                    let newShell = UIImageView(image: nil)
                    newShell.image = UIImage.animatedImage(with: self.shellImageArray, duration: 0.6)
                    newShell.frame = oldFrame
                    newShell.frame.size.width = 35
                    newShell.frame.size.height = 35
                    self.view.addSubview(newShell)
                    self.gravityBehavior.addItem(newShell)
                    // Play sound
                    let kickPath =  Bundle.main.path(forResource:"smw_stomp.wav", ofType: nil)!
                    let kickUrl = URL(fileURLWithPath: kickPath)
                    do{
                        self.kickSoundEffect = try AVAudioPlayer(contentsOf: kickUrl)
                        self.kickSoundEffect?.play()
                    }
                    catch{
                       print("Couldn't load audio file")
                    }
                }
            }
        }
        
        imageArray = [UIImage(named: "mario1.png")!,UIImage(named:"mario2.png")!,UIImage(named:"mario3.png")! ]
        draggedImageArray = [UIImage(named: "dmario1.png")!,UIImage(named:"dmario2.png")!,UIImage(named:"dmario3.png")! ]
        marioView.image = UIImage.animatedImage(with: imageArray, duration: 0.4)
        
        koopaImageArray = [UIImage(named: "wingkoopa1.png")!,UIImage(named:"wingkoopa2.png")!,UIImage(named:"wingkoopa3.png")!,UIImage(named:"wingkoopa4.png")!,UIImage(named:"wingkoopa5.png")! ]
        shellImageArray = [UIImage(named: "shell1.png")!,UIImage(named:"shell2.png")!,UIImage(named:"shell3.png")!,UIImage(named:"shell4.png")!]
        
        koopaImage = UIImage.animatedImage(with: koopaImageArray, duration: 0.6)
        enemyArray = Array<UIImageView>()

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
    
    func moveAndDestroy(_ image: UIImageView, speed: Int) {
        /*let translation = -image.frame.width
        let newCenter = CGPoint(x: translation, y: image.center.y)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            image.center = newCenter
            print(image.frame)
        }) { (success: Bool) in
            //image.transform = CGAffineTransform.identity
            print(image.frame)
            self.enemyCollisionBehavior.removeItem(image)
           image.removeFromSuperview()
        }*/
        dynamicItemBehavior.addItem(image)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: speed, y: 0), for: image)
    }
    
    func generateEnemy(){
        let newEnemy = UIImageView(image: nil)
        newEnemy.image = koopaImage
        let yc = Int.random(in: 60 ..< 300)
        newEnemy.frame = CGRect(x:Int(UIScreen.main.bounds.width + newEnemy.frame.width), y: yc, width: 60, height: 60)
        enemyArray.append(newEnemy)
        self.view.addSubview(newEnemy)
        let speed = Int.random(in: -200 ..< -100)
        self.moveAndDestroy(newEnemy, speed: speed)
        enemyCollisionBehavior.addItem(newEnemy)
        let delay = Float.random(in: 0.5 ..< 4.5)
        let enemyDelay =  DispatchTime.now() + Double(delay)
        DispatchQueue.main.asyncAfter(deadline: enemyDelay) {
            self.generateEnemy()
        }
    }
    
    
    func beginDrag() {
        self.dragging = true
        marioView.image = UIImage.animatedImage(with: draggedImageArray, duration: 0.4)
        gravityBehavior.removeItem(marioView)
        collisionBehavior.removeItem(marioView)
    }
    
    func endDrag() {
        self.dragging = false
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
    
    func updateBoundary() {
        enemyCollisionBehavior.removeAllBoundaries()
        enemyCollisionBehavior.addBoundary(withIdentifier: "marioBound" as NSCopying, for: UIBezierPath(rect: marioView.frame))
    }
    
    func updateScore(){
        scoreLabel.text = "Score: " + String(score)
    }
}
