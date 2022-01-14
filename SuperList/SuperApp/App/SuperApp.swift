//
//  SuperListApp.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

/// Суперапп (основное приложение).
protocol SuperApp {

    /// Получение главного экрана супераппа.
    var rootViewController: UIViewController { get }
}
