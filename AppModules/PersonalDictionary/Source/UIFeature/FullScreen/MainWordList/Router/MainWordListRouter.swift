//
//  Router.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

/// Роутер для навигации от Главного списка слов к другим экранам приложения.
protocol MainWordListRouter {

    /// Перейти на экран добавления нового слова.
    func navigateToNewWord()

    /// Перейти на экран поиска по словам в личном словаре.
    func navigateToSearch()
}
