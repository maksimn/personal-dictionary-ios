//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> SearchTextInputMVVM {
        let viewParams = SearchTextInputViewParams(
            placeholder: Bundle(for: type(of: self)).moduleLocalizedString("Enter a word for searching"),
            size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44)
        )

        return SearchTextInputMVVMImpl(viewParams: viewParams)
    }
}
