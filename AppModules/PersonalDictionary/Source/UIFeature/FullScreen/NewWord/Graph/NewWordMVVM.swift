//
//  NewWordMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// MVVM-граф фичи "Добавление нового слова" в личный словарь.
protocol NewWordMVVM {

    /// View controller экрана "Добавления нового слова" в личный словарь.
    var viewController: UIViewController? { get }
}
