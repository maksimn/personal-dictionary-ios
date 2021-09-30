//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

class NewWordViewModelImpl: NewWordViewModel {

    private unowned let view: NewWordView
    private let model: NewWordModel

    init(model: NewWordModel, view: NewWordView) {
        self.model = model
        self.view = view
    }

    func bindDataFromModel() {
        model.bindData()
    }

    var allLangs: [String] = [] {
        didSet {
            view.set(allLangs: allLangs)
        }
    }

    var sourceLang: String = "" {
        didSet {
            view.set(sourceLang: sourceLang)
        }
    }

    var targetLang: String = "" {
        didSet {
            view.set(targetLang: targetLang)
        }
    }
}
