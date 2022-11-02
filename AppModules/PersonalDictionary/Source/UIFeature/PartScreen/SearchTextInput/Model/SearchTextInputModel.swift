//
//  SearchTextInputModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Модель элемента ввода поискового текста.
protocol SearchTextInputModel: AnyObject {

    /// Делегат фичи
    var listener: SearchTextInputListener? { get set }

    /// Получить поисковый текст
    var searchText: String { get }
}

/// Делегат фичи "Элемент ввода поискового текста".
protocol SearchTextInputListener: AnyObject {

    /// Обработчик события изменения поискового текста.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func onSearchTextChanged(_ searchText: String)
}
