//
//  UIColor+CustomColors.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

extension UIColor {
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    public static let hotRed = rgba(207, 45, 48)
    public static let coldBlue = rgba(57, 89, 209)
    
    // Light theme
    public static let offWhite = rgba(239, 239, 239)
    public static let translucentBlack = rgba(0, 0, 0, 0.5)
    
    // Dark theme
    public static let nightGrey = rgba(36, 36, 36)
    public static let translucentWhite = rgba(255, 255, 255, 0.5)
}
