//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Билдер Фичи "Главный (основной) список слов" Личного словаря.
protocol MainWordListBuilder {

    /// Создать объекты фичи.
    /// - Returns:
    ///  - Navigation controller с проинициализированным первым экраном  "Главного (основного) списка слов".
    func build() -> UINavigationController
}
