//
//  SuperListAppBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

/// Билдер супераппа ("основного приложения").
protocol SuperAppBuilder {

    /// Создать экземпляр супераппа.
    func build() -> SuperApp
}
