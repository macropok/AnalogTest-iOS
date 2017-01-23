//
//  DisclosureIndicator.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

enum ArrowDirection : Int {
    case top
    case bottom
}

class DisclosureIndicator: UIView {
    
    convenience init(direction:ArrowDirection) {
        self.init(frame:CGRect.zero)
        self.direction = direction
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var direction : ArrowDirection?
    
    override func draw(_ rect: CGRect) {
        let width = rect.size.width
        let padding : CGFloat = width/2
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.round
        path.lineWidth = 2.0
        
        if(self.direction == ArrowDirection.bottom) {
            let origin = CGPoint(x: width / 4, y: 3 * width / 8)
            path.move(to: origin)
            path.addLine(to: CGPoint(x: width/2, y: 5 * width / 8))
            path.addLine(to: CGPoint(x: 3 * width / 4, y: 3 * width / 8))
            UIColor.darkGray.setStroke()
            path.stroke()
        }   else {
            let origin = CGPoint(x: width/4, y: 5*width/8)
            path.move(to: origin)
            path.addLine(to: CGPoint(x: width/2, y: 3*width/8))
            path.addLine(to: CGPoint(x: 3*width/4,y: 5*width/8))
            UIColor.darkGray.setStroke()
            path.stroke()
        }

    }

}
