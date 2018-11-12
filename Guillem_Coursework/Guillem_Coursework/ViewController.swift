//
//  ViewController.swift
//  Guillem_Coursework
//
//  Created by gf18aak on 05/11/2018.
//  Copyright © 2018 Guillem Frasquet. All rights reserved.
//

import UIKit


protocol subviewDelegate {
    func changeSomething()
}


class ViewController: UIViewController{
    
    
    @IBOutlet weak var bgSky: UIImageView!
    @IBOutlet weak var bgSun: UIImageView!
    @IBOutlet weak var bgClouds: UIImageView!
    @IBOutlet weak var bgMountains1: UIImageView!
    @IBOutlet weak var bgMountains2: UIImageView!
    @IBOutlet weak var bgRoad: UIImageView!
    
    @IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var bee: UIImageView!
    
    
    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior:UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    
    var beeEnemyArray = [UIImageView]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIView.animate(withDuration: 60, /*options: [.repeat],*/animations: {
            //UIView.setAnimationRepeatCount(10)
            self.bgSun.center.x -= self.view.bounds.width}, completion: nil)
        
        UIView.animate(withDuration: 3, delay: 0, options: [UIViewAnimationOptions.curveLinear, .repeat, .autoreverse],  animations:  {self.bgSun.alpha=0.8},completion:nil)
        
        UIView.animate(withDuration: 110, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgClouds.center.x -= self.view.bounds.width})
        
        UIView.animate(withDuration: 55, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgMountains1.center.x -= self.view.bounds.width})
        
        UIView.animate(withDuration: 45, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgMountains2.center.x -= self.view.bounds.width})
        
        UIView.animate(withDuration: 15, delay: 0, options: [.curveLinear, .repeat], animations: {self.bgRoad.center.x -= self.view.bounds.width}, completion: nil)
        
        
        
        var birdArray: [UIImage]!
        
        birdArray = [UIImage(named: "frame-1.png")!,
                     UIImage(named: "frame-2.png")!,
                     UIImage(named: "frame-3.png")!,
                     UIImage(named: "frame-4.png")!,
                     UIImage(named: "frame-5.png")!,
                     UIImage(named: "frame-6.png")!,
                     UIImage(named: "frame-7.png")!,
                     UIImage(named: "frame-8.png")!
        ]
        
        bird.image = UIImage.animatedImage(with: birdArray,duration: 0.5)

        
        var totalsecs = 0
        var secs = 0
        var firstbee = true
        
        // Boundaries
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        //gravityBehavior = UIGravityBehavior(items: [bird])
        //dynamicAnimator.addBehavior(gravityBehavior)
        //collisionBehavior.addBoundary(withIdentifier: "road" as NSCopying, for: UIBezierPath(rect: bgRoad.frame))

        
        for i in 1...15{
            if(!firstbee){
                secs = Int(arc4random_uniform(3)+1)
            
            }
            else{
                firstbee = false
            }
            
            totalsecs += secs   //the bee will appear after 2 to 4 seconds of the last bee
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(totalsecs)) {
                // Your code for actions when the time is up}
                //Create a new UIImageView from scratch
                
                self.createBeeEnemy()
                
                
                
            }
            

            
        }
        
        
        
        
        
        /* */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBeeEnemy() {
        var beeView = UIImageView(image: nil)
        
        //Assign an array of images to the image view
        var beeArray: [UIImage]!
        
        beeArray = [UIImage(named: "bee1.png")!,
                    UIImage(named: "bee2.png")!,
                    UIImage(named: "bee3.png")!,
                    UIImage(named: "bee4.png")!,
                    UIImage(named: "bee5.png")!,
                    UIImage(named: "bee6.png")!
        ]
        
        beeView.image = UIImage.animatedImage(with: beeArray,duration: 0.5)
        //beeView.image = UIImage(named: "bee1.png")
        
        //Assign the size and position of the image view
        let screenSize = UIScreen.main.bounds
        let xpos = screenSize.width;
        let ypos = arc4random_uniform(UInt32(screenSize.height - 100));
        //Int.random(in: 10...screenSize.height);
        
        beeView.frame = CGRect(x:xpos, y: CGFloat(ypos), width: 60, height: 50)
        
        UIView.animate(withDuration: Double(arc4random_uniform(13) + 7), delay: 0, options: [.curveLinear], animations: {
            beeView.center.x -= self.view.bounds.width + 60}, completion: nil)
        
        //Add the image view to the main view
        self.view.addSubview(beeView)
        
        beeEnemyArray.append(beeView)
        
        
        collisionBehavior = UICollisionBehavior(items: [bird,beeView])
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        collisionBehavior.addBoundary(withIdentifier: "obstacle" as NSCopying, for: UIBezierPath(rect: beeView.frame))
        
        dynamicAnimator.addBehavior(collisionBehavior)
    }


}

