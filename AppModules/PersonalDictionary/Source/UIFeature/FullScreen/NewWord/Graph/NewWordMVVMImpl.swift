//
//  NewWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Реализация MVVM-графа фичи "Добавление нового слова" в личный словарь.
final class NewWordMVVMImpl: NewWordMVVM {

    /// View controller экрана "Добавления нового слова" в личный словарь.
    private(set) var viewController: UIViewController?

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
        let model = NewWordModelImpl(langRepository, newWordItemStream)
        let viewModel = NewWordViewModelImpl(model: model)
        let view = NewWordViewController(params: viewParams,
                                         viewModel: viewModel,
                                         langPickerBuilder: langPickerBuilder)

        model.viewModel = viewModel
        viewController = view
    }
}
