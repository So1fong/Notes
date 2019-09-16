//
//  PushButton.swift
//  Notes
//
//  Created by Kateryna Kozlova on 12/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

protocol CheckStateOfPushButtons
{
    func checkState() -> Bool
    func performSegue()
}

class PushButton: UIControl
{
    var checked = false
    var checkMark: CheckMark?
    var delegate: CheckStateOfPushButtons?
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let path = UIBezierPath(rect: rect)
        self.backgroundColor?.setFill()
        path.fill()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setupGestures()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:)))
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longTap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleLongTap(_ sender: UITapGestureRecognizer)
    {
        if sender.state == .ended
        {
            if self.checked
            {
                delegate?.performSegue()
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        checked = (delegate?.checkState())!
        if checked
        {
            self.checkMark = CheckMark(frame: CGRect(x: self.bounds.size.width/2, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height/2))
            self.checkMark?.backgroundColor = self.backgroundColor
            ColorPickerViewController.setColor(color: self.backgroundColor!)
            self.isSelected = true
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations:
            {
                self.addSubview(self.checkMark!)
            })
        }
        else
        {
            self.isSelected = false
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations:
            {
                ColorPickerViewController.setColor(color: .white)
                self.checkMark?.removeFromSuperview()
                self.checkMark = nil
            })
        }
    }
}
