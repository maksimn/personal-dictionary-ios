//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация билдера фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerBuilder: ViewBuilder {

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UIView {
        let viewParams = SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("Search by:"),
            sourceWordText: bundle.moduleLocalizedString("source word"),
            translationText: bundle.moduleLocalizedString("translation")
        )
        let model = SearchModePickerModelImpl(searchModeStream: SearchModeStreamImpl.instance)
        let view = SearchModePickerView(params: viewParams, model: model)

        return view
    }
}
