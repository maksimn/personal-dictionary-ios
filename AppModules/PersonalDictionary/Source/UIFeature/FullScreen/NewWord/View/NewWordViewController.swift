//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

/// View Controller экрана добавления нового слова в личный словарь.
final class NewWordViewController: UIViewController, LangPickerListener, UITextFieldDelegate {

    let params: NewWordViewParams

    private let viewModel: NewWordViewModel

    var langPickerGraph: LangPickerGraph? // Child Feature

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления фичи "Добавление нового слова"
    ///  - viewModel: модель представления.
    ///  - langPickerBuilder: билдер вложенной фичи "Выбор языка"
    init(params: NewWordViewParams,
         viewModel: NewWordViewModel,
         langPickerBuilder: LangPickerBuilder) {
        self.params = params
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        initViews()
        add(langPickerBuilder)
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITextFieldDelegate

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel.update(text: textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewWordEventAndDismiss()
        return true
    }

    // MARK: - LangPickerListener

    func onLangPickerStateChanged(_ state: LangPickerState) {
        viewModel.update(langPickerState: state)
    }

    // MARK: - User Action Handlers

    @objc
    func onSourceLangLabelTap() {
        viewModel.presentLangPicker(langType: .source)
    }

    @objc
    func onTargetLangLabelTap() {
        viewModel.presentLangPicker(langType: .target)
    }

    @objc
    func onOkButtonTap() {
        sendNewWordEventAndDismiss()
    }

    // MARK: - Private

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            self?.set(state: state)
        }).disposed(by: disposeBag)
    }

    private func set(state: NewWordState) {
        textField.text = state.text
        sourceLangLabel.text = state.sourceLang.name
        targetLangLabel.text = state.targetLang.name
        langPickerGraph?.uiview.isHidden = state.isLangPickerHidden
        langPickerGraph?.model?.state = state.langPickerState
    }

    private func sendNewWordEventAndDismiss() {
        viewModel.sendNewWord()
        dismiss(animated: true, completion: nil)
    }
}
