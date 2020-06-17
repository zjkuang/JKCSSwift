//
//  StringExtentions.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-13.
//  Copyright © 2020 Kuang. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    func isPad() -> Bool {
        return (self.userInterfaceIdiom == .pad)
    }
    
    func isPhone() -> Bool {
        return (self.userInterfaceIdiom == .phone)
    }
    
    func currentInterfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
                return interfaceOrientation
            }
            else {
                return .unknown
            }
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    func isPortrait() -> Bool {
        return currentInterfaceOrientation().isPortrait
    }
    
    func isLandscape() -> Bool {
        return currentInterfaceOrientation().isLandscape
    }

}
