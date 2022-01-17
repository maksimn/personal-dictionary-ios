//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Представление элемента ввода поискового текста.
protocol SearchTextInputView: AnyObject {

    /// Модель представления элемента ввода поискового текста.
    var viewModel: SearchTextInputViewModel? { get set }

    /// UIView элемента ввода поискового текста.
    var uiview: UIView { get }

    /// Задать поисковый текст для представления.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func set(_ searchText: String)
}
