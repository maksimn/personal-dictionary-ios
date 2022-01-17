//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Хранилище данных о языках в приложении,
protocol LangRepository {

    /// Список всех языков
    var allLangs: [Lang] { get }

    /// Сохранить и извлечь исходный язык
    var sourceLang: Lang { get set }

    /// Сохранить и извлечь целевой язык
    var targetLang: Lang { get set }
}
