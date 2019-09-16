//
//  ColorPicker.swift
//  Notes
//
//  Created by Kateryna Kozlova on 13/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//
import UIKit

protocol ColorPickerProtocol
{
    func getColor()
}

class ColorPicker: UIView
{
    var currentPosition = CGPoint(x: 0, y: 0)
    var delegate: ColorPickerProtocol?
    var currentColor = UIColor.white
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        setupTap()
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
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    }
    
    func getColor(at point: CGPoint) -> UIColor
    {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        let color = UIColor(red:   CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue:  CGFloat(pixel[2]) / 255.0,
                            alpha: CGFloat(pixel[3]) / 255.0)
        pixel.deallocate()
        return color
    }
    
    @objc func handlePan(_ sender: UITapGestureRecognizer)
    {
        currentPosition = sender.location(in: self)
        currentColor = getColor(at: currentPosition)
        delegate?.getColor()
    }

}
