//
//  NewWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Реализация MVVM-графа фичи "Добавление нового слова" в личный словарь.
final class NewWordMVVMImpl: NewWordMVVM {

    private let view: NewWordViewController

    /// Инициализатор.
    /// - Parameters:
    ///  - langRepository: хранилище с данными о языках в приложении.
    ///  - newWordItemStream: поток для отправки событий добавления нового слова в словарь
    ///  - viewParams: параметры представления фичи "Добавление нового слова"
    ///  - langPickerBuilder: билдер вложенной фичи "Выбор языка"
    init(langRepository: LangRepository,
         newWordItemStream: NewWordItemStream,
         viewParams: NewWordViewParams,
         langPickerBuilder: LangPickerBuilder) {
        view = NewWordViewController(params: viewParams, langPickerBuilder: langPickerBuilder)
        let model = NewWordModelImpl(langRepository, newWordItemStream)
        let viewModel = NewWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        model.bindInitially()
    }

    /// View controller экрана "Добавления нового слова" в личный словарь.
    var viewController: UIViewController? {
        view
    }
}
