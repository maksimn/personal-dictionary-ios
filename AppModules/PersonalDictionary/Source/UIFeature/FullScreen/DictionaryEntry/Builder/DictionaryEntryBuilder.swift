//
//  DictionaryEntryBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule
import UIKit

struct DictionaryEntryBuilder: ParametrizedViewControllerBuilder {

    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build(_ id: Word.Id) -> UIViewController {
        let model = DictionaryEntryModelImpl(id: id)
        let viewModel = DictionaryEntryViewModelImpl(model: model)
        let view = DictionaryEntryViewController(
            viewModel: viewModel,
            errorText: bundle.moduleLocalizedString("LS_LOAD_DICTIONARY_ENTRY_ERROR"),
            theme: Theme.data
        )

        return view
    }
}
