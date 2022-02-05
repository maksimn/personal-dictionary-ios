//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxCocoa

/// Модель представления элемента ввода поискового текста.
protocol SearchTextInputViewModel: AnyObject {

    /// Поисковый текст для представления
    var searchText: PublishRelay<String> { get }
}
