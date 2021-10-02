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

    private var isPickerSelectingSourceLang: Bool = false

    let textField = UITextField()

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

extension NewWordViewVC {

    @objc
    func onSourceLangLabelTap() {
        isPickerSelectingSourceLang = true
    }

    @objc
    func onTargetLangLabelTap() {
        isPickerSelectingSourceLang = false
    }

    @objc func onOkButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
