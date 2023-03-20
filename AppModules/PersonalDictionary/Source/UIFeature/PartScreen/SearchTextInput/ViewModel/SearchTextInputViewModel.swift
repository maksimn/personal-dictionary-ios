//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Модель элемента ввода поискового текста.
protocol SearchTextInputViewModel {

    var searchText: BindableString { get }

    var mainScreenState: BindableMainScreenState { get }
}
