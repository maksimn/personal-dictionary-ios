//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// View Controller экрана добавления нового слова в личный словарь.
final class NewWordViewController: UIViewController, NewWordView, LangPickerListener, UITextFieldDelegate {

    /// View model "Добавления нового слова" в личный словарь.
    var viewModel: NewWordViewModel?

    let params: NewWordViewParams

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()

    private var langPickerMVVM: LangPickerMVVM? // Child Feature

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления фичи "Добавление нового слова"
    ///  - langPickerBuilder: билдер вложенной фичи "Выбор языка"
    init(params: NewWordViewParams,
         langPickerBuilder: LangPickerBuilder) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
        langPickerMVVM = langPickerBuilder.build()
        initViews()
        addChildFeature(langPickerMVVM: langPickerMVVM)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Задать данные для отображения в представлении.
    /// - Parameters:
    ///  - state: данные для отображения.
    func set(state: NewWordModelState?) {
        guard let state = state else { return }
        textField.text = state.text
        sourceLangLabel.text = state.sourceLang.name
        targetLangLabel.text = state.targetLang.name
    }

    // MARK: - UITextFieldDelegate

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel?.updateModel(text: textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewWordEventAndDismiss()
        return true
    }

    // MARK: - LangPickerListener

    func onLangSelected(_ data: LangSelectorData) {
        viewModel?.updateModel(data: data)
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
        viewModel?.sendNewWord()
        dismiss(animated: true, completion: nil)
    }

    private func showLangPickerView(selectedLangType: SelectedLangType) {
        guard let lang = selectedLangType == .source ? viewModel?.state?.sourceLang :
                                                       viewModel?.state?.targetLang else { return }
        guard let langPickerModel = langPickerMVVM?.model else { return }

        langPickerMVVM?.uiview?.isHidden = false
        langPickerModel.initData = LangSelectorData(selectedLang: lang, selectedLangType: selectedLangType)
    }
}
