//
//  MainNavigatorBuilder.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

/// Билдер фичи "Контейнер элементов навигации на Главном экране приложения".
protocol MainNavigatorBuilder {

    /// Создать контейнер.
    /// - Returns: объект контейнера.
    func build() -> MainNavigator
}
