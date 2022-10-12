//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Контейнер элементов навигации на Главном экране приложения.
protocol MainNavigator {

    /// Добавить представления элементов навигации.
    func appendTo(rootView: UIView)
}
