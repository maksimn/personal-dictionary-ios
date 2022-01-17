//
//  SearchTextInputModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Модель элемента ввода поискового текста.
protocol SearchTextInputModel: AnyObject {

    /// Модель представления элемента ввода поискового текста.
    var viewModel: SearchTextInputViewModel? { get set }

    /// Делегат фичи
    var listener: SearchTextInputListener? { get set }

    /// Получить поисковый текст
    var searchText: String { get }

    /// Обновить поисковый текст.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func update(_ searchText: String)
}

/// Делегат фичи "Элемент ввода поискового текста".
protocol SearchTextInputListener: AnyObject {

    /// Обработчик события изменения поискового текста.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func onSearchTextChanged(_ searchText: String)
}
