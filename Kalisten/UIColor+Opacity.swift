//
//  UIColor+Opacity.swift
//  Kalisten
//
//  Created by Pedro Solís García on 05/02/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

extension UIColor {
    func opacity(percentage: Int) -> UIColor {
        return self.withAlphaComponent(CGFloat(percentage)/100.0)
    }
}
