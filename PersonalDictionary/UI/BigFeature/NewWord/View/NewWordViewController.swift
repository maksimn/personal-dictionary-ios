//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class NewWordViewController: UIViewController, NewWordView, LangPickerListener, UITextFieldDelegate {

    var viewModel: NewWordViewModel?

    let params: NewWordViewParams

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()

    private var langPickerMVVM: LangPickerMVVM? // Child Feature

    init(params: NewWordViewParams,
         langPickerBuilder: LangPickerBuilder) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
        langPickerMVVM = langPickerBuilder.build()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        addChildFeature(langPickerMVVM: langPickerMVVM)
    }

    func set(text: String) {
        textField.text = text
    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }

    // MARK: - UITextFieldDelegate

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel?.text = textField.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewWordEventAndDismiss()
        return true
    }

    // MARK: - LangPickerListener

    func onLangSelected(_ data: LangSelectorData) {
        langPickerMVVM?.uiview?.isHidden = true
        viewModel?.updateModel(data.selectedLangType, data.selectedLang)
    }

    // MARK: - User Action Handlers

    @objc
    func onSourceLangLabelTap() {
        showLangPickerView(selectedLangType: .source)
    }

    @objc
    func onTargetLangLabelTap() {
        showLangPickerView(selectedLangType: .target)
    }

    @objc
    func onOkButtonTap() {
        sendNewWordEventAndDismiss()
    }

    // MARK: - Private

    private func sendNewWordEventAndDismiss() {
        viewModel?.sendNewWordEvent()
        dismiss(animated: true, completion: nil)
    }

    private func showLangPickerView(selectedLangType: SelectedLangType) {
        guard let lang = selectedLangType == .source ? viewModel?.sourceLang : viewModel?.targetLang else { return }
        guard let langPickerModel = langPickerMVVM?.model else { return }

        langPickerMVVM?.uiview?.isHidden = false
        langPickerModel.data = LangSelectorData(selectedLang: lang, selectedLangType: selectedLangType)
    }
}
