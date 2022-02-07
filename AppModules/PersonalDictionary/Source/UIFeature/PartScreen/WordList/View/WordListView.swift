//
//  WordListView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Представление списка слов.
protocol WordListView: AnyObject {

    /// Задать данные для показа в представлении.
    /// - Parameters:
    ///  - wordList: данные о списке слов.
    func set(_ wordList: [WordItem])
}
