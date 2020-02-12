//
//  UILocalizedTabBarItem.swift
//  Kalisten
//
//  Created by Pedro Solís García on 06/02/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

final class UILocalizedTabBarItem: UITabBarItem {
    override func awakeFromNib() {
        super.awakeFromNib()

        title = title?.localized()
    }
}
