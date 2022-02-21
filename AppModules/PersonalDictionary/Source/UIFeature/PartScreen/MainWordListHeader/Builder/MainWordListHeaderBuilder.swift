//
//  MainWordListHeaderBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Заголовок Главного списка слов".
protocol MainWordListHeaderBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
