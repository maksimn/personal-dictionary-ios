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

    /// View model "Добавления нового слова" в личный словарь.
    private let viewModel: NewWordViewModel

    let params: NewWordViewParams

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()

    private var langPickerMVVM: LangPickerMVVM? // Child Feature

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
        langPickerMVVM = langPickerBuilder.build()
        initViews()
        addChildFeature(langPickerMVVM: langPickerMVVM)
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

    func onLangSelected(_ data: LangSelectorData) {
        viewModel.update(data: data)
    }

    // MARK: - User Action Handlers

    @objc
    func onSourceLangLabelTap() {
        viewModel.presentLangPickerView(selectedLangType: .source)
    }

    @objc
    func onTargetLangLabelTap() {
        viewModel.presentLangPickerView(selectedLangType: .target)
    }

    @objc
    func onOkButtonTap() {
        sendNewWordEventAndDismiss()
    }

    // MARK: - Private

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }

            self.textField.text = state.text
            self.sourceLangLabel.text = state.sourceLang.name
            self.targetLangLabel.text = state.targetLang.name
            self.langPickerMVVM?.uiview?.isHidden = state.isLangPickerHidden

            if !state.isLangPickerHidden {
                self.langPickerMVVM?.model?.data = LangSelectorData(
                    selectedLang: state.selectedLangType == .source ? state.sourceLang : state.targetLang,
                    selectedLangType: state.selectedLangType
                )
            }
        }).disposed(by: disposeBag)
    }

    private func sendNewWordEventAndDismiss() {
        viewModel.sendNewWord()
        dismiss(animated: true, completion: nil)
    }
}
