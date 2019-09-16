//
//  PushButton.swift
//  Notes
//
//  Created by Kateryna Kozlova on 12/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class PushButton: UIView
{
    private var isSelected = false
    var checkMark: CheckMark?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupTap()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let path = UIBezierPath(rect: rect)
        UIColor.green.setFill()
        path.fill()
    }
    
    private func setupTap()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        if !isSelected
        {
            self.checkMark = CheckMark(frame: CGRect(x: self.bounds.size.width/2, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height/2))
            self.checkMark?.backgroundColor = .green
            self.isSelected = true
            self.addSubview(self.checkMark!)
        }
        else
        {
            self.isSelected = false
            self.checkMark?.removeFromSuperview()
            self.checkMark = nil
        }
    }

}
