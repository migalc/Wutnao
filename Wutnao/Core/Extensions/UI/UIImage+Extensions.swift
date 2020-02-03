//
//  UIImage+Extensions.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import UIKit

// MARK: UIImage Extensions

extension UIImage {
    struct RotationOptions: OptionSet {
        let rawValue: Int

        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }

    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero

        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)

            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {

        let newWidth = newSize.width
        let newHeight = newSize.height
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    
    func rotatedImage(deviceOrientation: UIDeviceOrientation) -> UIImage? {
        switch deviceOrientation {
        case .landscapeLeft:
            return rotated(by: .init(value: -90, unit: .degrees))
        case .portraitUpsideDown:
            return rotated(by: .init(value: 180, unit: .degrees))
        case .landscapeRight:
            return rotated(by: .init(value: 90, unit: .degrees))
        default:
            return self
        }

    }
    
}
