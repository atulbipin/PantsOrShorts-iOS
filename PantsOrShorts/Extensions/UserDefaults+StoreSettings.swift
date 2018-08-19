//
//  UserDefaults+StoreSettings.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-19.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

extension UserDefaults {
    public static let appGroupSuiteName = "group.com.POSShared"
    
    public static var shared: UserDefaults {
        get {
            return UserDefaults(suiteName: appGroupSuiteName)!
        }
    }
    
    public func save(_ value: Any, forKey key: String) {
        self.set(value, forKey: key)
        self.synchronize()
    }
}
