//
//  WordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule

/// Внешние зависимости фичи "Список слов".
protocol WordListExternals: MainWordListExternals {

    /// Операции create, update, delete со словами в хранилище личного словаря.
    var cudOperations: WordItemCUDOperations { get }

    /// Логгер
    var logger: Logger { get }
}
