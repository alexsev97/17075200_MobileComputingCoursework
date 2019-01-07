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
    
    // Stop game
    var stopGame = false
    var level = 0
    
    // Enemy character images
    var koopaImage: UIImage!
    var koopaImageArray: [UIImage]!
    var enemyArray: [UIImageView]!
    var shellImageArray: [UIImage]!
    
    // Coin image array
    var coinImageArray: [UIImage]!
    var coinImage: UIImage!
    var coinArray: [UIImageView]!
    
    // Sound effects
    var kickSoundEffect: AVAudioPlayer?
    var kickPath: String?
    var kickUrl: URL?
    
    var coinSoundEffect: AVAudioPlayer?
    var coinPath: String?
    var coinUrl: URL?
    
    var levelMusic: AVAudioPlayer?
    var levelMusicPath: String?
    var levelMusicUrl: URL?
    
    
    // Text label containing the score
    @IBOutlet weak var scoreLabel: UITextField!
    var score = 0
    
    // Behavior items
    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    
    var enemyCollisionBehavior: UICollisionBehavior!
    var coinCollisionBehavior: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the layout work in every iOS device
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
        
        // Assign sounds
        kickPath = Bundle.main.path(forResource:"smw_stomp.wav", ofType: nil)!
        kickUrl = URL(fileURLWithPath: kickPath!)
        
        coinPath = Bundle.main.path(forResource:"sm64_coin.wav", ofType: nil)!
        coinUrl = URL(fileURLWithPath: coinPath!)
        
        levelMusicPath = Bundle.main.path(forResource:"levelMusic.mp3", ofType: nil)!
        levelMusicUrl = URL(fileURLWithPath: levelMusicPath!)
        
        // MOve the background
        self.moveInLoop(self.background1View, duration: 15, translation: -528)
        self.moveInLoop(self.background2View, duration: 15, translation: -528)
        self.moveInLoop(self.background3View, duration: 15, translation: -528)
        self.moveInLoop(self.groundView, duration: 0.3, translation: -37)
        self.moveInLoop(self.cloud1View, duration: 23, translation: -150)
        self.moveInLoop(self.cloud2View, duration: 23, translation: -500)
        
        // Initiate dynamic animator
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        // Initiate gravity behaviour
        gravityBehavior = UIGravityBehavior.init()
        dynamicAnimator.addBehavior(gravityBehavior)
        gravityBehavior.magnitude = 0.4
        
        // Initiate collision behaviour (Mario with the ground)
        collisionBehavior = UICollisionBehavior.init()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        collisionBehavior.addBoundary(withIdentifier: "groundBound" as NSCopying, for: UIBezierPath(rect: groundView.frame))
        
        // Initiate collision behaviour (enemies with Mario)
        enemyCollisionBehavior = UICollisionBehavior.init()
        enemyCollisionBehavior.collisionMode = UICollisionBehavior.Mode.boundaries
        enemyCollisionBehavior.translatesReferenceBoundsIntoBoundary = false
        dynamicAnimator.addBehavior(enemyCollisionBehavior)
        
        enemyCollisionBehavior.action = {
            for item in self.enemyArray{
                // Check every item for intersection with Mario
                if(item.frame.intersects(self.marioView.frame)) {
                    self.score -= 5
                    self.updateScore() // Update score text label
                    // Remove all behaviours from item
                    self.dynamicItemBehavior.removeItem(item)
                    self.enemyCollisionBehavior.removeItem(item)
                    let oldFrame = item.frame
                    item.removeFromSuperview()
                    item.frame = CGRect.zero
                    
                    // Change Mario image when he is hit
                    self.marioView.image = UIImage(named: "hitMario.png")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        // Go back to dragging image
                        if (self.dragging){
                            self.marioView.image = UIImage.animatedImage(with: self.draggedImageArray, duration: 0.4)
                        }
                            // Go back to normal image
                        else{
                            self.marioView.image = UIImage.animatedImage(with: self.imageArray, duration: 0.4)
                        }
                    }
                    
                    // Create new shell when enemy hit
                    let newShell = UIImageView(image: nil)
                    newShell.image = UIImage.animatedImage(with: self.shellImageArray, duration: 0.6)
                    newShell.frame = oldFrame
                    newShell.frame.size.width = 35
                    newShell.frame.size.height = 35
                    self.view.addSubview(newShell)
                    self.gravityBehavior.addItem(newShell)
                    
                    // Play sound
                    do{
                        self.kickSoundEffect = try AVAudioPlayer(contentsOf: self.kickUrl!)
                        self.kickSoundEffect?.play()
                    }
                    catch{
                        print("Couldn't load audio file")
                    }
                }
            }
        }
        
        // Initiate collision behaviour (coins with Mario)
        coinCollisionBehavior = UICollisionBehavior.init()
        coinCollisionBehavior.collisionMode = UICollisionBehavior.Mode.boundaries
        coinCollisionBehavior.translatesReferenceBoundsIntoBoundary = false
        dynamicAnimator.addBehavior(coinCollisionBehavior)
        
        coinCollisionBehavior.action = {
            for item in self.coinArray{
                // Check every coin for intersection with Mario
                if(item.frame.intersects(self.marioView.frame)) {
                    self.score += 15
                    self.updateScore() // Update score text label
                    self.dynamicItemBehavior.removeItem(item)
                    self.coinCollisionBehavior.removeItem(item)
                    item.removeFromSuperview()
                    item.frame = CGRect.zero
                    // Play sound
                    do{
                        self.coinSoundEffect = try AVAudioPlayer(contentsOf: self.coinUrl!)
                        self.coinSoundEffect?.play()
                    }
                    catch{
                        print("Couldn't load audio file")
                    }
                    
                }
            }
        }
        
        // Mario animation
        imageArray = [UIImage(named: "mario1.png")!,UIImage(named:"mario2.png")!,UIImage(named:"mario3.png")! ]
        draggedImageArray = [UIImage(named: "dmario1.png")!,UIImage(named:"dmario2.png")!,UIImage(named:"dmario3.png")! ]
        marioView.image = UIImage.animatedImage(with: imageArray, duration: 0.4)
        
        // Koopa enemy animation
        koopaImageArray = [UIImage(named: "wingkoopa1.png")!,UIImage(named:"wingkoopa2.png")!,UIImage(named:"wingkoopa3.png")!,UIImage(named:"wingkoopa4.png")!,UIImage(named:"wingkoopa5.png")! ]
        shellImageArray = [UIImage(named: "shell1.png")!,UIImage(named:"shell2.png")!,UIImage(named:"shell3.png")!,UIImage(named:"shell4.png")!]
        
        koopaImage = UIImage.animatedImage(with: koopaImageArray, duration: 0.6)
        enemyArray = Array<UIImageView>()
        
        // Coin animation
        coinImageArray = [UIImage(named: "coin1.png")!,UIImage(named:"coin2.png")!,UIImage(named:"coin3.png")!,UIImage(named:"coin4.png")!,UIImage(named:"coin5.png")!,UIImage(named:"coin6.png")!,UIImage(named:"coin7.png")!,UIImage(named:"coin8.png")!,UIImage(named:"coin9.png")! ]
        coinImage = UIImage.animatedImage(with: coinImageArray, duration: 1)
        coinArray = Array<UIImageView>()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Position Mario to always start in the same place
        marioView.frame = CGRect(x: 40, y: 75, width: 46, height: 75)
        gravityBehavior.addItem(marioView)
        collisionBehavior.addItem(marioView)
        
        // Everytime the view appears, we increase the level of the game
        // That way we make it a challenge, with more enemies that move faster
        level += 1
        
        // Call function to start random generation of enemies and coins
        stopGame = false
        generateEnemy()
        generateCoin()
        
        // Update actual score
        self.updateScore()
        
        // Start level music
        do{
            self.levelMusic = try AVAudioPlayer(contentsOf: self.levelMusicUrl!)
            self.levelMusic?.play()
            self.levelMusic?.volume = 0.5
        }
        catch{
            print("Couldn't load audio file")
        }
        
        // Timer for game end
        let endGame = DispatchTime.now() + 20.5
        DispatchQueue.main.asyncAfter(deadline: endGame) {
            self.performSegue(withIdentifier: "timerSegue", sender: self)
        }
    }
    
    // Function to move in loop background and floor
    func moveInLoop(_ image: UIImageView, duration: Double, translation: CGFloat) {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: translation, y: 0)
            }) { (success: Bool) in
                image.transform = CGAffineTransform.identity
                self.moveInLoop(image, duration: duration, translation: translation)
            }
        }
    
    // Function to move enemies and coins (so it works with their collision behaviour)
    func moveAndDestroy(_ image: UIImageView, speed: Int) {
        dynamicItemBehavior.addItem(image)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: speed, y: 0), for: image)
    }
    
    // Function to generate random enemies
    func generateEnemy(){
        if(!stopGame){
            // Create new enemy
            let newEnemy = UIImageView(image: nil)
            newEnemy.image = koopaImage
            // Randomise the height in which they appear in the screen
            let h = UIScreen.main.bounds.height - 100
            let yc = Int.random(in: 60 ..< Int(h))
            newEnemy.frame = CGRect(x:Int(UIScreen.main.bounds.width + newEnemy.frame.width), y: yc, width: 60, height: 60)
            enemyArray.append(newEnemy)
            self.view.addSubview(newEnemy)
            var speed: Int = 0
            var delay: Float = 0.0
            // According to the level, we create more or less enemies at more or less speed
            if (level == 1){
                speed = Int.random(in: -150 ..< -100)
                delay = Float.random(in: 4 ..< 4.5)
            }
            else if (level == 2){
                speed = Int.random(in: -200 ..< -150)
                delay = Float.random(in: 3.25 ..< 4)
            }
            else if (level == 3){
                speed = Int.random(in: -250 ..< -200)
                delay = Float.random(in: 2.5 ..< 3.75)
            }
            else if (level == 4){
                speed = Int.random(in: -300 ..< -250)
                delay = Float.random(in: 1.5 ..< 3)
            }
            else if (level >= 5){
                speed = Int.random(in: -350 ..< -300)
                delay = Float.random(in: 0.7 ..< 1.5)
            }
            self.moveAndDestroy(newEnemy, speed: speed)
            enemyCollisionBehavior.addItem(newEnemy)
            
            // We call this function again after a random delay
            let enemyDelay =  DispatchTime.now() + Double(delay)
            DispatchQueue.main.asyncAfter(deadline: enemyDelay) {
                self.generateEnemy()
            }
        }
    }
    
    // Function to generate random coins
    func generateCoin(){
        if(!stopGame){
            let newCoin = UIImageView(image: nil)
            newCoin.image = coinImage
            // Randomise height of coins
            let yc = Int.random(in: 60 ..< 250)
            newCoin.frame = CGRect(x:Int(UIScreen.main.bounds.width + newCoin.frame.width), y: yc, width: 30, height: 30)
            coinArray.append(newCoin)
            self.view.addSubview(newCoin)
            let speed = Int.random(in: -150 ..< -50)
            self.moveAndDestroy(newCoin, speed: speed)
            coinCollisionBehavior.addItem(newCoin)
            
            var delay: Float = 0
            
            // If the player is in a higher level, generate more coins
            if (level == 1){
                delay = Float.random(in: 4 ..< 4.3)
            }
            else if (level == 2){
                delay = Float.random(in: 3.25 ..< 4)
            }
            else if (level == 3){
                delay = Float.random(in: 2.5 ..< 3.75)
            }
            else if (level == 4){
                delay = Float.random(in: 1.5 ..< 3)
            }
            else if (level >= 5){
                delay = Float.random(in: 0.9 ..< 1.5)
            }
            
            // We call this function again after a random delay
            let coinDelay =  DispatchTime.now() + Double(delay)
            DispatchQueue.main.asyncAfter(deadline: coinDelay) {
                self.generateCoin()
            }
        }
    }
    
    // Function executed when the user starts dragging Mario
    func beginDrag() {
        self.dragging = true
        marioView.image = UIImage.animatedImage(with: draggedImageArray, duration: 0.4)
        // Remove gravity and collision with boundaries while he is being dragged
        gravityBehavior.removeItem(marioView)
        collisionBehavior.removeItem(marioView)
    }
    
    // Function executed when the user stops dragging Mario
    func endDrag() {
        self.dragging = false
        // Update to non drag image
        marioView.image = UIImage.animatedImage(with: imageArray, duration: 0.4)
        // Add all behaviours
        gravityBehavior.addItem(marioView)
        collisionBehavior.addItem(marioView)
        enemyCollisionBehavior.removeAllBoundaries()
    }
    
    // Check for collision from Mario with the ground
    func checkCollision() -> Bool {
        if (marioView.frame.intersects(groundView.frame)){
            return true
        }
        return false
    }
    
    // Update Mario boundary as he is being dragged
    func updateBoundary() {
        enemyCollisionBehavior.removeAllBoundaries()
        enemyCollisionBehavior.addBoundary(withIdentifier: "marioBound" as NSCopying, for: UIBezierPath(rect: marioView.frame))
    }
    
    // Update score text label
    func updateScore(){
        scoreLabel.text = "Score: " + String(score)
    }
    
    // Pass score information to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "timerSegue"){
        let endViewController = segue.destination as! EndViewController
            endViewController.score = self.score
        }
    }
    
    // This function executes when the game has ended
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        score = 0
        // Remove all enemies
        for item in self.enemyArray{
            item.removeFromSuperview()
            item.frame = CGRect.zero
        }
        // Remove all coins
        for item in self.coinArray{
            item.removeFromSuperview()
            item.frame = CGRect.zero
        }
        // Stop dragging
        if (self.dragging){
            self.endDrag()
        }
        // Remov all behaviours from Mario
        gravityBehavior.removeItem(marioView)
        collisionBehavior.removeItem(marioView)
        enemyCollisionBehavior.removeAllBoundaries()

        stopGame = true
        // Clear arrays
        self.enemyArray.removeAll()
        self.coinArray.removeAll()
    }
}
