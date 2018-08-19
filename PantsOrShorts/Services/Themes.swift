//
//  Themes.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

public struct ThemeColors {
    let textColor: UIColor
    let backgroundColor: UIColor
}

public enum Theme {
    case night
    case day
    
    public func getColors() -> ThemeColors {
        switch self {
        case .night:
            return ThemeColors(textColor: .white, backgroundColor: .nightGrey)
        case .day:
            return ThemeColors(textColor: .black, backgroundColor: .offWhite)
        }
    }
}
