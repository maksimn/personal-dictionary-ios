//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

class NewWordViewModelImpl: NewWordViewModel {

    private weak var view: NewWordView?
    private let model: NewWordModel

    init(model: NewWordModel, view: NewWordView) {
        self.model = model
        self.view = view
    }

    var state: NewWordModelState? {
        didSet {
            view?.set(state: state)
        }
    }

    func sendNewWord() {
        model.sendNewWord()
    }

    func updateModel(text: String) {
        model.update(text: text)
    }

    func updateModel(data: LangSelectorData) {
        model.update(data: data)
    }
}
