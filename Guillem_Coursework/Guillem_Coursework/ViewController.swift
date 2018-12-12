//
//  ViewController.swift
//  Guillem_Coursework
//
//  Created by gf18aak on 05/11/2018.
//  Copyright © 2018 Guillem Frasquet. All rights reserved.
//

import UIKit
import AVFoundation


protocol subviewDelegate {
    func changeSomething()
}


class ViewController: UIViewController, subviewDelegate {
    
    
    @IBOutlet weak var bgSky: UIImageView!
    @IBOutlet weak var bgSun: UIImageView!
    @IBOutlet weak var bgClouds: UIImageView!
    @IBOutlet weak var bgMountains1: UIImageView!
    @IBOutlet weak var bgMountains2: UIImageView!
    @IBOutlet weak var bgRoad: UIImageView!
    
    //@IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var bird: DraggedImageView!
    @IBOutlet weak var bee: UIImageView!
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishLabel: UILabel!
    
    @IBOutlet weak var startView: UIView!
    
    
    @IBOutlet weak var howToPlayView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var ambientMusic: AVAudioPlayer?
    var beeCollisionSound: AVAudioPlayer?
    var blueCoinSound: AVAudioPlayer?
    
    var gameEnded = false
    
    var execution = 0
    var nexecutions = 0
    
    var score = 0
    
    var collisionProtection = false     //var to protect bird from collisions
    var collisionProtectionCoins = false
    
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var dynamicCoinsBehavior: UIDynamicItemBehavior!
    var dynamicBlueCoinBehavior: UIDynamicItemBehavior!
    
    
    var collisionBehavior:UICollisionBehavior!
    var collisionCoinsBehavior:UICollisionBehavior!
    var collisionBlueCoinBehavior:UICollisionBehavior!
    
    var gravityBehavior: UIGravityBehavior!
    
    var beeEnemyArray = [UIImageView]()
    var coinArray = [UIImageView]()
    
    
    var blueCoinView = UIImageView(image: nil)
    
    
    @IBOutlet weak var finishViewMountains: UIImageView!
    
    
    
    @IBAction func startGameButton(_ sender: UIButton) {
        startGame()
        
        startView.isHidden = true
    }
    
    
    
    
    @IBOutlet weak var startViewMountains: UIImageView!
    
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    
    
    var birdArray: [UIImage]!
    var birdHitArray: [UIImage]!
    var coinImageArray: [UIImage]!
    var blueCoinImageArray: [UIImage]!
    
    
    var blueCoinsActive = false
    
    
    
    
    
    
    func startGame(){
        gameEnded = false
        
        nexecutions += 1
        execution = nexecutions
        
        blueCoinsActive = false
        
        self.blueCoinView.frame = (CGRect(x:-100, y:-100, width:0, height:0))
        print(self.blueCoinView.frame)
        
        score = 0
        scoreLabel.text = String(score)
        setBirdOrigin()
        
        birdArray = [UIImage(named: "frame-1.png")!,
                     UIImage(named: "frame-2.png")!,
                     UIImage(named: "frame-3.png")!,
                     UIImage(named: "frame-4.png")!,
                     UIImage(named: "frame-5.png")!,
                     UIImage(named: "frame-6.png")!,
                     UIImage(named: "frame-7.png")!,
                     UIImage(named: "frame-8.png")!
        ]
        
        birdHitArray = [UIImage(named: "birdhit-1.png")!,
                        UIImage(named: "birdhit-2.png")!]
        
        
        coinImageArray = [UIImage(named: "star coin rotate 1.png")!,
                          UIImage(named: "star coin rotate 2.png")!,
                          UIImage(named: "star coin rotate 3.png")!,
                          UIImage(named: "star coin rotate 4.png")!,
                          UIImage(named: "star coin rotate 5.png")!,
                          UIImage(named: "star coin rotate 6.png")!
        ]
        
        blueCoinImageArray = [UIImage(named: "blue coin 1.png")!,
                              UIImage(named: "blue coin 2.png")!,
                              UIImage(named: "blue coin 3.png")!,
                              UIImage(named: "blue coin 4.png")!,
                              UIImage(named: "blue coin 5.png")!,
                              UIImage(named: "blue coin 6.png")!
        ]
        
        self.ambientMusic?.setVolume(3, fadeDuration: 1)
        
        
        bgSun.startAnimating()
        bgClouds.startAnimating()
        bgMountains1.startAnimating()
        bgMountains2.startAnimating()
        bgRoad.startAnimating()
 
        
 
        //animateBackground()
        
        bird.image = UIImage.animatedImage(with: birdArray,duration: 0.5)
        
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicCoinsBehavior = UIDynamicItemBehavior(items: [])
        dynamicBlueCoinBehavior = UIDynamicItemBehavior(items: [])
        
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        dynamicAnimator.addBehavior(dynamicCoinsBehavior)
        dynamicAnimator.addBehavior(dynamicBlueCoinBehavior)
        
        
        collisionBehavior = UICollisionBehavior(items: [])
        collisionCoinsBehavior = UICollisionBehavior(items: [])
        collisionBlueCoinBehavior = UICollisionBehavior(items: [])

        
        dynamicAnimator.addBehavior(collisionBehavior)
        dynamicAnimator.addBehavior(collisionCoinsBehavior)
        dynamicAnimator.addBehavior(collisionBlueCoinBehavior)
        
        //Add main avatar as a boundary
        collisionBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: bird.frame))
        collisionBehavior.addBoundary(withIdentifier: "road" as NSCopying, for: UIBezierPath(rect: bgRoad.frame))
        collisionCoinsBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: bird.frame))
        collisionCoinsBehavior.addBoundary(withIdentifier: "road" as NSCopying, for: UIBezierPath(rect: bgRoad.frame))
        collisionBlueCoinBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: bird.frame))
        collisionBlueCoinBehavior.addBoundary(withIdentifier: "road" as NSCopying, for: UIBezierPath(rect: bgRoad.frame))
        

        //collisionBehavior.collisionMode = UICollisionBehavior.Mode.boundaries
        
        
        /*collisionBehavior.action = {
         self.score -= 10
         self.scoreLabel.text = String(self.score)
         }*/
        
        
        
        createEnemies()
        
        createCoins()
        
        createBigBlueCoin()
        
        collisionBehavior.action = {
            var numberOfBees = self.beeEnemyArray.count-1
            if(numberOfBees < 0){
                numberOfBees = 0
            }
            
            for i in 0...numberOfBees {
                
                if(!self.collisionProtection && !self.beeEnemyArray.isEmpty)
                {
                    if(self.bird.frame.intersects(self.beeEnemyArray[i].frame))
                    {
                        self.collisionProtection = true
                        if(self.score > 0){
                            self.score -= 10
                        }
                        self.scoreLabel.text = String(self.score)
                        
                        
                        UIView.animate(withDuration: 0.2, delay: 0, options: [UIViewAnimationOptions.curveLinear, .repeat, .autoreverse],  animations:  {self.beeEnemyArray[i].alpha=0},completion:nil)
                        //self.beeEnemyArray[i].frame = CGRect.zero
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            if(i < self.beeEnemyArray.count){   //to avoid error if beeenemyArray has been emptied during the second of waiting -case time's up-
                                self.beeEnemyArray[i].removeFromSuperview()
                                self.beeEnemyArray[i].frame = CGRect.zero
                            }
                            
                        }
                        
                        
                        
                        //Change bird animation to hit animation
                        self.bird.image = UIImage.animatedImage(with: self.birdHitArray,duration: 0.5)
                        
                        //Sound effect
                        let path = Bundle.main.path(forResource:"beeCollision.wav", ofType:nil)!
                        let url = URL(fileURLWithPath: path)
                        do{
                            self.beeCollisionSound = try AVAudioPlayer(contentsOf:url)
                            self.beeCollisionSound?.play()
                            self.beeCollisionSound?.setVolume(3, fadeDuration: 0)
                            
                        }
                        catch{
                            // couldn't load file :(
                        }
                        
                        //Bird image animation restored to the normal one after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            self.collisionProtection = false
                            self.bird.image = UIImage.animatedImage(with: self.birdArray,duration: 0.5)
                        }
                    }
                    
                    
                }
                
            }
        }
        
        collisionCoinsBehavior.action = {
    
            var toRemove = [Int]()
            var numberOfCoins = self.coinArray.count-1
            if(numberOfCoins < 0){
                numberOfCoins = 0
            }
            
            for j in 0...numberOfCoins {
                //print(self.coinArray.count)
                if(j < self.coinArray.count && self.bird.frame.intersects(self.coinArray[j].frame))
                {
                    if(!self.blueCoinsActive){
                        self.score += 10
                    }
                    else{
                        self.score += 20
                    }
                    
                    self.scoreLabel.text = String(self.score)
                    
                    self.coinArray[j].removeFromSuperview()
                    toRemove.append(j)
                    
                    
                    
                    
                    //Sound effect
                    let path = Bundle.main.path(forResource:"coin.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)
                    do{
                        self.beeCollisionSound = try AVAudioPlayer(contentsOf:url)
                        self.beeCollisionSound?.play()
                        self.beeCollisionSound?.setVolume(3, fadeDuration: 0)
                        
                    }
                    catch{
                        // couldn't load file :(
                    }
                }
            }
            ///////////////////!!!!!!!!!!!!!!!! FATAL ERROR IF 2 COINS COLLECTED AT THE SAME TIME!!!!!!!
            if(toRemove.count > 0){
                for k in 0...toRemove.count-1{
                    if(toRemove.count > 0){
                        self.coinArray.remove(at: toRemove[k])
                    }
                }
                
                toRemove.removeAll()
            }
            
        }
        
        collisionBlueCoinBehavior.action = {
            if(self.bird.frame.intersects(self.blueCoinView.frame))
            {
                self.blueCoinView.frame = CGRect.zero
                self.blueCoinsActive = true
                
                //Sound effect
                let path = Bundle.main.path(forResource:"blueCoin.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                do{
                    self.blueCoinSound = try AVAudioPlayer(contentsOf:url)
                    self.blueCoinSound?.play()
                    self.blueCoinSound?.setVolume(3, fadeDuration: 0)
                    
                }
                catch{
                    // couldn't load file :(
                }
                
                if(self.coinArray.count > 0){
                    for i in 0...self.coinArray.count-1{
                        self.coinArray[i].image = UIImage.animatedImage(with: self.blueCoinImageArray,duration: 0.7)
                    }
                }
                //print("BLUE COIN")
                
            }
        }
        
        
        startTimer()
    }
    
    
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        //beeEnemyArray.removeAll()
        
        self.finishView.isHidden = true
        //animateBackground()
        let items = dynamicItemBehavior.items
        for i in items {
            dynamicItemBehavior.removeItem(i)
        }
        
        let coins = dynamicCoinsBehavior.items
        for i in coins {
            dynamicCoinsBehavior.removeItem(i)
        }
        
        /*for i in 0...beeEnemyArray.count-1 {
            beeEnemyArray[i].removeFromSuperview()
            
        }*/
        beeEnemyArray.removeAll()
        coinArray.removeAll()
        self.finishViewMountains.stopAnimating()
        
        
        /*
        startTimer()
        
        createEnemies()
        createCoins()
        //setCollisions()
        
 */
        
        
        
        startGame()
        
        self.ambientMusic?.setVolume(3, fadeDuration: 1)
        
        self.gameEnded = false
    }
    
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    
    @IBAction func goMenuButton(_ sender: UIButton) {
        finishView.isHidden = true
        startView.isHidden = false
        self.view.bringSubview(toFront: startView)
    }
    
    
    @IBAction func goHowToPlayButton(_ sender: UIButton) {
        howToPlayView.isHidden = false
        self.view.bringSubview(toFront: howToPlayView)
    }
    
    
    @IBAction func closeHowToPlayButton(_ sender: UIButton) {
        howToPlayView.isHidden = true
    }
    
    
    
    func changeSomething() {
        collisionBehavior.removeAllBoundaries()
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: bird.frame))
    }
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bird.myDelegate = self
        
        UIView.animate(withDuration: 110, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.startViewMountains.center.x -= self.view.bounds.width - 250
        })
        
        view.bringSubview(toFront: startView)
        
        finishView.isHidden = true
        //finishView.isHidden = false
        howToPlayView.isHidden = true
        
        animateBackground()
        
        
        //Play ambient music
        let path = Bundle.main.path(forResource:"Magical-Getaway_Looping.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do{
            ambientMusic = try AVAudioPlayer(contentsOf:url)
            ambientMusic?.play()
            self.ambientMusic?.setVolume(3, fadeDuration: 1)
            ambientMusic?.numberOfLoops = -1
            
        }
        catch{
            // couldn't load file :(
        }
        

        
        ///////////
        
    }
    
    
    func animateBackground(){
        UIView.animate(withDuration: 60, /*options: [.repeat],*/animations: {
            //UIView.setAnimationRepeatCount(10)
            self.bgSun.center.x -= self.view.bounds.width}, completion: nil)
        
        UIView.animate(withDuration: 3, delay: 0, options: [UIViewAnimationOptions.curveLinear, .repeat, .autoreverse],  animations:  {self.bgSun.alpha=0.8},completion:nil)
        
        UIView.animate(withDuration: 110, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgClouds.center.x -= self.view.bounds.width})
        
        UIView.animate(withDuration: 55, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgMountains1.center.x -= self.view.bounds.width - 50})
        
        UIView.animate(withDuration: 45, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgMountains2.center.x -= self.view.bounds.width - 50})
        
        UIView.animate(withDuration: 11, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgRoad.center.x -= self.view.bounds.width}, completion: nil)

        
    }
    
    var firsttime = true
    
    func startTimer(){
        
        self.timerLabel.text = String(20)
        
        
        for i in 1...20{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i)) {
                self.timerLabel.text = String(20-i)
                //print("Time: " + String(20-i))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
            self.timeIsUp()
        }
    }
    
    func timeIsUp() {
        print("TIME'S UP!")
        self.finalScoreLabel.text = String(self.score)
        
        let defaults = UserDefaults.standard
        var highscore = defaults.integer(forKey: "highscore")
        if(self.score > highscore){
            highscore = self.score
            defaults.set(highscore, forKey: "highscore")
        }
        self.highScoreLabel.text = "High score: " + String(highscore)
        
        
        self.finishView.isHidden = false
        self.view.bringSubview(toFront: self.finishView)
        self.removeAllEnemies()
        self.removeAllCoins()
        self.ambientMusic?.setVolume(1, fadeDuration: 1)
        self.gameEnded = true
        self.blueCoinView.frame = CGRect.zero
        if(self.firsttime){
            UIView.animate(withDuration: 45, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.finishViewMountains.center.x -= self.view.bounds.width-250})
            self.firsttime = false   //45  / self.view.bounds.width-80
        }
        else{
            self.finishViewMountains.startAnimating()
        }
        
        /*
         self.bgSun.layer.removeAllAnimations()
         self.bgClouds.layer.removeAllAnimations()
         self.bgMountains1.layer.removeAllAnimations()
         self.bgMountains2.layer.removeAllAnimations()
         self.bgRoad.layer.removeAllAnimations()
         */
    }
    
    func createBeeEnemy() {
        let beeView = UIImageView(image: nil)
        
        //Assign an array of images to the image view
        var beeArray: [UIImage]!
        
        beeArray = [UIImage(named: "bee1.png")!,
                    UIImage(named: "bee2.png")!,
                    UIImage(named: "bee3.png")!,
                    UIImage(named: "bee4.png")!,
                    UIImage(named: "bee5.png")!,
                    UIImage(named: "bee6.png")!
        ]
        
        beeView.image = UIImage.animatedImage(with: beeArray,duration: 0.4)
        //beeView.image = UIImage(named: "bee1.png")
        
        //Assign the size and position of the image view
        let screenSize = UIScreen.main.bounds
        let xpos = screenSize.width;
        let ypos = arc4random_uniform(UInt32(screenSize.height - 100));
        //ypos = UInt32(screenSize.height/2-50) //to test collision with the initial position of the bird
        beeView.frame = CGRect(x:xpos, y: CGFloat(ypos), width: 60, height: 50)
        
        /*UIView.animate(withDuration: Double(arc4random_uniform(13) + 7), delay: TimeInterval(delay), options: [.curveLinear], animations: {
         beeView.center.x -= self.view.bounds.width + 60}, completion: nil)*/
        
        
        
        //dynamicItemBehavior = UIDynamicItemBehavior(items: [beeView])
        self.view.addSubview(beeView)
        
        dynamicItemBehavior.addItem(beeView)
        
        let velx = -1 * (Int(arc4random_uniform(90) + 110))
        //let velx = upperValue
        
        dynamicItemBehavior.addLinearVelocity(CGPoint(x:velx, y:0), for: beeView)
        
        
        
        collisionBehavior.addItem(beeView)
        
        //collisionBehavior.collisionMode
        
        /*collisionBehavior.action = {
         if(self.bird.frame.intersects(beeView.frame))
         {
         self.score -= 10
         self.scoreLabel.text = String(self.score)
         }
         
         }*/
        
        beeEnemyArray.append(beeView)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
            // Your code for actions when the time is up
            UIView.animate(withDuration: 0.5, delay: 0, options: [UIViewAnimationOptions.curveEaseOut],  animations:  {beeView.alpha=0},completion:nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/2)) {
                beeView.removeFromSuperview()
                beeView.frame = CGRect.zero
            }
            }
        
        collisionBehavior.addBoundary(withIdentifier: "road" as NSCopying, for: UIBezierPath(rect: bgRoad.frame))

        
    }
    
    func createEnemies(){
        var totalsecs = 0
        var secs = 0
        var firstbee = true
        
        for i in 1...15{
            if(!firstbee){
                secs = Int(arc4random_uniform(2)+1)
                
            }
            else{
                firstbee = false
            }
            
            totalsecs += secs   //the bee will appear after 2 to 4 seconds of the last bee
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(totalsecs)) {
            // Your code for actions when the time is up
                if(!self.gameEnded){
                    self.createBeeEnemy()
                }
            }
            //Create a new UIImageView from scratch
            
            
        }
        
    }
    
    
    func removeAllEnemies() {
        if(beeEnemyArray.count > 0){
        for i in 0...beeEnemyArray.count-1
            {
                beeEnemyArray[i].removeFromSuperview()
            }
        }
        beeEnemyArray.removeAll()
    }
    
    
    func createCoin() {
        let coinView = UIImageView(image: nil)
        
        
        if(!blueCoinsActive){
            coinView.image = UIImage.animatedImage(with: coinImageArray,duration: 0.7)
        }
        else{
            coinView.image = UIImage.animatedImage(with: blueCoinImageArray,duration: 0.7)
        }

        
        //Assign the size and position of the image view
        let screenSize = UIScreen.main.bounds
        let xpos = screenSize.width;
        let ypos = arc4random_uniform(UInt32(screenSize.height - 100));

        coinView.frame = CGRect(x:xpos, y: CGFloat(ypos), width: 30, height: 30)
        
        self.view.addSubview(coinView)
        
        dynamicCoinsBehavior.addItem(coinView)
       
        let velx = -90

        dynamicCoinsBehavior.addLinearVelocity(CGPoint(x:velx, y:0), for: coinView)
        
        
        
        collisionCoinsBehavior.addItem(coinView)
        
        //collisionBehavior.collisionMode = bird

        
        coinArray.append(coinView)
        
        
    }
    
    func createCoins(){
        var totalsecsCoins = 0
        var secsCoin = 0
        var firstcoin = true
        
        for i in 1...15{
            if(!firstcoin){
                secsCoin = Int(arc4random_uniform(2)+1)
                
            }
            else{
                firstcoin = false
            }
            
            totalsecsCoins += secsCoin   //the bee will appear after 2 to 4 seconds of the last bee
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(totalsecsCoins)) {
                // Your code for actions when the time is up
                if(!self.gameEnded){
                    self.createCoin()
                }
            }
            //Create a new UIImageView from scratch
            
            
        }
    }
    
    
    func removeAllCoins(){
        if(coinArray.count > 0){
            for i in 0...coinArray.count-1
            {
                coinArray[i].removeFromSuperview()
            }
            
        }
        coinArray.removeAll()
    }
    
    
    func createBigBlueCoin() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(14)) {
            //Assign an array of images to the image view
            var blueCoinImageArray: [UIImage]!
            
            
            blueCoinImageArray = [UIImage(named: "blue coin 1.png")!,
                                  UIImage(named: "blue coin 2.png")!,
                                  UIImage(named: "blue coin 3.png")!,
                                  UIImage(named: "blue coin 4.png")!,
                                  UIImage(named: "blue coin 5.png")!,
                                  UIImage(named: "blue coin 6.png")!
            ]
            
            self.blueCoinView.image = UIImage.animatedImage(with: blueCoinImageArray,duration: 1)
            
            
            //Assign the size and position of the image view
            let screenSize = UIScreen.main.bounds
            let xpos = screenSize.width;
            let ypos = arc4random_uniform(UInt32(screenSize.height - 100));
            
            self.blueCoinView.frame = CGRect(x:xpos, y: CGFloat(ypos), width: 60, height: 60)
            
            self.view.addSubview(self.blueCoinView)
            
            self.dynamicBlueCoinBehavior.addItem(self.blueCoinView)
            
            let velx = -1 * (Int(arc4random_uniform(140) + 180))
            
            self.dynamicBlueCoinBehavior.addLinearVelocity(CGPoint(x:velx, y:0), for: self.blueCoinView)
            
            
            
            self.collisionBlueCoinBehavior.addItem(self.blueCoinView)
        }
        
    }
    
    
    
    
    
    
    
    
    func setCollisions(){
        //dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        //collisionBehavior = UICollisionBehavior(items: [/*bird,*/ beeEnemyArray[0]])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        /*for i in 0...14{
         collisionBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: beeEnemyArray[i].frame))
         }*/
        
        //Add main avatar as a boundary
        //collisionBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: bird.frame))
        
        //print("bird:")
        //print(bird.frame)
        
        //dynamicAnimator.addBehavior(collisionBehavior)
        
        
        /*collisionBehavior.action = {
            self.score -= 10
            self.scoreLabel.text = String(self.score)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func setBirdOrigin() {
        bird.frame.origin.x = 20
        bird.frame.origin.y = 163
    }
    
    


}

/*
class CountDownViewController: UIViewController{
    var timer = Timer()
    var timeRemaining = 20
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func timerRunning() {
            timeRemaining -= 1
            
            timeLabel.text = timeRemaining
            manageTimerEnd(seconds: timeRemaining)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        
    }
}
 */
