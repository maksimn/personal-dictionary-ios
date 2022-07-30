//
//  NavToNewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

protocol NavToEditorBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
