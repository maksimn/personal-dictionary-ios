//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Представление "Добавления нового слова" в личный словарь.
protocol NewWordView: AnyObject {

    /// View model "Добавления нового слова" в личный словарь.
    var viewModel: NewWordViewModel? { get set }

    /// Задать данные для отображения в представлении.
    /// - Parameters:
    ///  - state: данные для отображения.
    func set(state: NewWordModelState?)
}
