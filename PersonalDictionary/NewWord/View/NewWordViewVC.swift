//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class NewWordViewVC: UIViewController, NewWordView {

    var viewModel: NewWordViewModel?

    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.bindDataFromModel()
    }

    func set(allLangs: [Lang]) {

    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }
}
