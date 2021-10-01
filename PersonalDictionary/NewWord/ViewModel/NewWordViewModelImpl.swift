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

    var allLangs: [Lang] = [] {
        didSet {
            view.set(allLangs: allLangs)
        }
    }

    var sourceLang: Lang = Langs.empty {
        didSet {
            view.set(sourceLang: sourceLang)
            model.save(sourceLang: sourceLang)
        }
    }

    var targetLang: Lang = Langs.empty {
        didSet {
            view.set(targetLang: targetLang)
            model.save(targetLang: targetLang)
        }
    }

    func bindDataFromModel() {
        model.bindData()
    }
}
