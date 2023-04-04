//
//  Bundle+Core.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 19.12.2021.
//

import UIKit

extension Bundle {

    public func moduleLocalizedString(_ text: String) -> String {
        localizedString(forKey: text, value: text, table: nil)
    }
}
