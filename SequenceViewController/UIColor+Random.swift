//
//  UIColor+Random.swift
//  SequenceViewController
//
//  Created by Robin Charlton on 11/02/2017.
//  Copyright © 2017 Robin Charlton. All rights reserved.
//

import UIKit

extension UIColor {

    class func random() -> UIColor {
        return UIColor(
            hue: CGFloat.random(min: 0.0, max: 1.0),
            saturation: CGFloat.random(min: 0.3, max: 0.6),
            brightness: CGFloat.random(min: 0.7, max: 1.0),
            alpha: 1.0)
    }
}

private extension CGFloat {

    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let number = Double(arc4random() % UINT32_MAX) / Double(UINT32_MAX)
        return min + CGFloat(Double(max - min) * number)
    }
}
