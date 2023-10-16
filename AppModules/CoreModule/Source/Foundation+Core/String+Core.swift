//
//  String+Core.swift
//  CoreModule
//
//  Created by Maksim Ivanov on 19.10.2023.
//

import Foundation

extension String {

    public func stripOutTags() -> String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
