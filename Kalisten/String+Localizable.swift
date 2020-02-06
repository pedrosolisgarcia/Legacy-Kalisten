//
//  StringLocalizable.swift
//  Kalisten
//
//  Created by Pedro Solís García on 05/02/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
