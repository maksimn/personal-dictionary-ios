//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация модели представления элемента ввода поискового текста.
final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    /// Поисковый текст для представления
    let searchText = BindableString(value: "")
}
