//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

class NewWordViewModelImpl: NewWordViewModel {

    private unowned let view: NewWordView
    private let model: NewWordModel

    private static let empty = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")

    init(model: NewWordModel, view: NewWordView) {
        self.model = model
        self.view = view
    }

    var text: String = "" {
        didSet {
            view.set(text: text)
        }
    }

    var allLangs: [Lang] = [] {
        didSet {
            view.set(allLangs: allLangs)
        }
    }

    var sourceLang: Lang = empty {
        didSet {
            view.set(sourceLang: sourceLang)
        }
    }

    var targetLang: Lang = empty {
        didSet {
            view.set(targetLang: targetLang)
        }
    }

    func save(sourceLang: Lang) {
        model.save(sourceLang: sourceLang)
    }

    func save(targetLang: Lang) {
        model.save(targetLang: targetLang)
    }

    func fetchDataFromModel() {
        model.fetchData()
    }

    func sendNewWordEvent() {
        model.sendNewWord()
    }
}
