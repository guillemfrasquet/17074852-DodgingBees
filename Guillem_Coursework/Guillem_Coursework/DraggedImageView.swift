//
//  DraggedImageView.swift
//  Guillem_Coursework
//
//  Created by gf18aak on 05/11/2018.
//  Copyright © 2018 Guillem Frasquet. All rights reserved.
//

import UIKit

class DraggedImageView: UIImageView {
    
    var startLocation: CGPoint?
    
    var myDelegate: subviewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        self.center = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
        
        self.myDelegate?.changeSomething()
        
        
        //Constraint movements into parent bounds
        
        
        //X
        //Get the value of the midpoint in x between the edges of the image (halfx)
        let halfx = self.bounds.midX
        
        //Assign the x of the image center as the highest value between halfx and the previously assigned center.x
        self.center.x = max(halfx, center.x)
        
        //Assign the x of the image center as the smallest value between the width of the edges of the screen minus halfx, and the center.x assigned in the previous line
        self.center.x = min((self.superview?.bounds.size.width)! - halfx, center.x)
        
        
        //Y
        //Get the value of the midpoint in and between the edges of the image (halfy)
        let halfy = self.bounds.midY
        
        //Assign the y of the image center as the highest value between halfy and the center.y previously assigned
        self.center.y = max(halfy, center.y)
        
        //Assign the y of the image center as the smallest value between the width of the edges of the least halfy screen, and the center.y assigned in the previous line
        self.center.y = min((self.superview?.bounds.size.height)! - halfy, center.y)
        
        
        
    }
    
}
