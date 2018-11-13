//
//  DraggedImageView.swift
//  Sevilla_Lab4App
//
//  Created by Alejandro Sevilla Romero  on 25/10/2018.
//  Copyright © 2018 Alejandro Sevilla Romero . All rights reserved.
//

import UIKit

class DraggedImageView: UIImageView {

    var startLocation: CGPoint?
    var myDelegate: subviewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.myDelegate?.beginDrag()
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newCenter = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
        
        // Constrain movement into parent bounds
        let halfx = self.bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(self.superview!.bounds.size.width - halfx, newCenter.x)
        let halfy = self.bounds.midY
        newCenter.y = max(halfy, newCenter.y)
        newCenter.y = min(self.superview!.bounds.size.height - halfy, newCenter.y)
        //let okToDrag = self.myDelegate?.checkCollision()
        let aux = self.center
        self.center = newCenter
        if (self.myDelegate?.checkCollision())!{
             self.center = aux
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.myDelegate?.endDrag()
    }

}
