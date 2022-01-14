//
//  PersonalDictionaryApp.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Приложение "Личный словарь иностранных слов".
public protocol PersonalDictionaryApp {

    /// Получение корневого контроллера приложения
    var navigationController: UINavigationController { get }
}
