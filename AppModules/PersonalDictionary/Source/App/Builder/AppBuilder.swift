//
//  AppBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

/// Билдер приложения "Личный словарь иностранных слов".
public protocol AppBuilder {

    /// Создание объекта данного приложения.
    /// - Returns: объект приложения.
    func build() -> App
}
