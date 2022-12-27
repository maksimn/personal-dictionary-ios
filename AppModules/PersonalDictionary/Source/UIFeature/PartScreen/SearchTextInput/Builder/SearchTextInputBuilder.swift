//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilder: ViewBuilder {

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UIView {
        let viewParams = SearchTextInputViewParams(
            placeholder: bundle.moduleLocalizedString("Enter a word for searching"),
            size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44)
        )
        let model = SearchTextInputModelImpl(searchTextStream: SearchTextStreamImpl.instance)
        let view = SearchTextInputView(params: viewParams, model: model)

        return view
    }
}
