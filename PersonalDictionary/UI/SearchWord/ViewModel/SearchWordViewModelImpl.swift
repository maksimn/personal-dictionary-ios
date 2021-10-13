//
//  SearchWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

final class SearchWordViewModelImpl: WordListViewModelImpl, SearchWordViewModel {

    init(model: SearchWordModel, view: SearchWordView, router: Router? = nil) {
        super.init(model: model, view: view, router: router)
    }

    private var viewOne: SearchWordView? {
        view as? SearchWordView
    }

    private var modelOne: SearchWordModel? {
        model as? SearchWordModel
    }

    override var wordList: [WordItem] {
        didSet {
            viewOne?.set(wordList: self.wordList)
            viewOne?.reloadList()
        }
    }

    var isMessageLabelHidden: Bool = true {
        didSet {
            viewOne?.setMessageLabel(hidden: isMessageLabelHidden)
        }
    }

    override func fetchDataFromModel() { }

    func prepareForSearching() {
        modelOne?.prepareForSearching()
    }

    func searchWord(contains string: String) {
        if string.count > 0 {
            modelOne?.searchWord(contains: string)
        } else {
            wordList = []
            isMessageLabelHidden = true
        }
    }
}
