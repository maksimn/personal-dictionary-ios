//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class NewWordViewVC: UIViewController, NewWordView {

    var viewModel: NewWordViewModel?

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()
    let langPickerPopup = LangPickerPopup()

    private var isSelectingSourceLang: Bool = false {
        didSet {
            if let lang = isSelectingSourceLang ? viewModel?.sourceLang : viewModel?.targetLang {
                langPickerPopup.select(lang: lang)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.bindDataFromModel()
    }

    func set(allLangs: [Lang]) {
        langPickerPopup.langPickerController.langs = allLangs
    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }
}

// User Action handlers
extension NewWordViewVC {

    @objc
    func onSourceLangLabelTap() {
        isSelectingSourceLang = true
        langPickerPopup.isHidden = false
    }

    @objc
    func onTargetLangLabelTap() {
        isSelectingSourceLang = false
        langPickerPopup.isHidden = false
    }

    @objc
    func onOkButtonTap() {
        dismiss(animated: true, completion: nil)
    }

    func onSelectLang(_ lang: Lang) {
        langPickerPopup.isHidden = true

        if isSelectingSourceLang {
            viewModel?.sourceLang = lang
        } else {
            viewModel?.targetLang = lang
        }
    }
}
