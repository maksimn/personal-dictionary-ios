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
    let arrowLabel = UILabel()

    let langPickerView = UIPickerView()
    let langPickerController = LangPickerController()

    private var isPickerSelectingSourceLang: Bool = false

    let textField = UITextField(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width - 70, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.bindDataFromModel()
    }

    func set(allLangs: [Lang]) {
        langPickerController.langs = allLangs
    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }
}

extension NewWordViewVC {

    @objc
    func onSourceLangLabelTap() {
        langPickerView.isHidden = false
        isPickerSelectingSourceLang = true
    }

    @objc
    func onTargetLangLabelTap() {
        langPickerView.isHidden = false
        isPickerSelectingSourceLang = false
    }

    func onSelectPicker(row: Int) {
        langPickerView.isHidden = true

        let selectedLang = langPickerController.langs[row]

        if isPickerSelectingSourceLang {
            viewModel?.sourceLang = selectedLang
        } else {
            viewModel?.targetLang = selectedLang
        }
    }
}
