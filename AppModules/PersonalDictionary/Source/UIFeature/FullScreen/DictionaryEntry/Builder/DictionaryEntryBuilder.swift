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
    private let ponsSecret: String

    init(bundle: Bundle, ponsSecret: String) {
        self.bundle = bundle
        self.ponsSecret = ponsSecret
    }

    func build(_ id: Word.Id) -> UIViewController {
        let model = DictionaryEntryModelImpl(
            id: id,
            dictionaryService: dictionaryService(),
            decoder: PonsDictionaryEntryDecoder(),
            updatedWordSender: WordStreamImpl.instance
        )
        let viewModel = DictionaryEntryViewModelImpl(model: model)
        let view = DictionaryEntryViewController(
            viewModel: viewModel,
            params: viewParams(),
            theme: Theme.data
        )

        return view
    }

    private func viewParams() -> DictionaryEntryViewParams {
        DictionaryEntryViewParams(
            errorText: bundle.moduleLocalizedString("LS_LOAD_DICTIONARY_ENTRY_ERROR"),
            retryButtonText: bundle.moduleLocalizedString("LS_DICTIONARY_ENTRY_RETRY_REQUEST")
        )
    }

    private func dictionaryService() -> DictionaryService {
        DictionaryServiceImpl(
            secret: ponsSecret,
            category: "PersonalDictionary.DictionaryEntry",
            bundle: bundle,
            isErrorSendable: false
        )
    }
}
