//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxCocoa

typealias BindableString = BehaviorRelay<String>

/// Модель представления элемента ввода поискового текста.
protocol SearchTextInputViewModel: AnyObject {

    /// Поисковый текст для представления
    var searchText: BindableString { get }
}
