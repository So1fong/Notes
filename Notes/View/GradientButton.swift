//
//  GradientButton.swift
//  Notes
//
//  Created by Kateryna Kozlova on 13/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

protocol GradientButtonTapped
{
    func gradientButtonTapped()
}

class GradientButton: UIView
{
    private var isSelected = false
    var delegate: GradientButtonTapped?
    
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
        let context = UIGraphicsGetCurrentContext()
        let elementSize: CGFloat = 1
        let saturationExponentTop: Float = 2.0
        let saturationExponentBottom: Float = 1.3
        
        for y in stride(from: 0, to: rect.height, by: elementSize)
        {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: 0, to: rect.width, by: elementSize)
            {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: x, y: y, width: elementSize, height: elementSize))
            }
        }
    }

    private func setupTap()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        self.delegate?.gradientButtonTapped()
    }
}
