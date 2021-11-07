//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class NewWordViewController: UIViewController, NewWordView {

    var viewModel: NewWordViewModel?

    let params: NewWordViewParams

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()
    var langPickerPopup: LangPickerPopup?

    private var isSelectingSourceLang: Bool = false {
        didSet {
            if let lang = isSelectingSourceLang ? viewModel?.sourceLang : viewModel?.targetLang {
                langPickerPopup?.select(lang: lang)
            }
        }
    }

    init(params: NewWordViewParams) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.fetchDataFromModel()
    }

    func set(text: String) {
        textField.text = text
    }

    func set(allLangs: [Lang]) {
        releaseLangPickerPopup()

        langPickerPopup = LangPickerPopup(langPickerController: LangPickerController(langs: allLangs),
                                          onSelectLang: { [weak self] lang in
                                            self?.onSelectLang(lang)
                                          },
                                          selectButtonTitle: params.staticContent.selectButtonTitle,
                                          backgroundColor: params.styles.backgroundColor,
                                          isHidden: true)

        layoutLangPickerPopup()
    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }

    private func sendNewWordEventAndDismiss() {
        viewModel?.sendNewWordEvent()
        dismiss(animated: true, completion: nil)
    }
}

// User Action handlers
extension NewWordViewController: UITextFieldDelegate {

    @objc
    func onSourceLangLabelTap() {
        isSelectingSourceLang = true
        langPickerPopup?.isHidden = false
    }

    @objc
    func onTargetLangLabelTap() {
        isSelectingSourceLang = false
        langPickerPopup?.isHidden = false
    }

    @objc
    func onOkButtonTap() {
        sendNewWordEventAndDismiss()
    }

    func onSelectLang(_ lang: Lang) {
        langPickerPopup?.isHidden = true

        if isSelectingSourceLang {
            viewModel?.sourceLang = lang
            viewModel?.save(sourceLang: lang)
        } else {
            viewModel?.targetLang = lang
            viewModel?.save(targetLang: lang)
        }
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel?.text = textField.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewWordEventAndDismiss()
        return true
    }
}
