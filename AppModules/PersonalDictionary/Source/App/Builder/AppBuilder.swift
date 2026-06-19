//
//  AppBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

/// Builder of the "Personal Dictionary" application.
public protocol AppBuilder {

    /// Create an application object.
    /// - Returns: application object.
    func build() -> App
}
