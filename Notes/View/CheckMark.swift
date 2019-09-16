//
//  PushButton.swift
//  Notes
//
//  Created by Kateryna Kozlova on 12/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class CheckMark: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let path = UIBezierPath()
        self.backgroundColor?.setFill()
        path.move(to: CGPoint(x: self.bounds.size.width / 8, y: self.bounds.size.height * 1.0 / 3.0))
        path.addLine(to: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height * 3.0 / 4.0))
        path.move(to: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height * 3.0 / 4.0))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 4.0 / 5.0, y: 0))
        path.close()
        path.lineWidth = 2
        UIColor.black.setStroke()
        path.stroke()
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        ovalPath.lineWidth = 1
        UIColor.black.setStroke()
        ovalPath.stroke()
    }
}
