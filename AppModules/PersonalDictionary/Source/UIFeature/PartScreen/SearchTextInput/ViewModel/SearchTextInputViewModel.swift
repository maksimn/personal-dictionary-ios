//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Модель представления элемента ввода поискового текста.
protocol SearchTextInputViewModel: AnyObject {

    /// Поисковый текст для представления
    var searchText: String { get set }

    /// Обновить поисковый текст в модели.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func updateModel(_ searchText: String)
}
