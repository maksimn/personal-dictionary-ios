//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import RxSwift
import UIKit

/// View Controller экрана добавления нового слова в личный словарь.
final class NewWordViewController: UIViewController, LangPickerListener, UITextFieldDelegate {

    let params: NewWordViewParams
    let theme: Theme
    private let logger: SLogger

    private let viewModel: NewWordViewModel

    private var langPickerGraph: LangPickerGraph? // Child Feature

    let contentView = UIView()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let arrowLabel = UILabel()
    let okButton = UIButton()
    let textField = UITextField()

    private let featureName = "PersonalDictionary.NewWord"

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления фичи "Добавление нового слова"
    ///  - viewModel: модель представления.
    ///  - langPickerBuilder: билдер вложенной фичи "Выбор языка"
    init(params: NewWordViewParams,
         viewModel: NewWordViewModel,
         langPickerBuilder: LangPickerBuilder,
         theme: Theme,
         logger: SLogger) {
        self.params = params
        self.theme = theme
        self.viewModel = viewModel
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
        initViews()
        addLangPicker(langPickerBuilder)
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(dismissedFeatureName: featureName)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log(installedFeatureName: featureName)
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

    // MARK: - LangPickerListener

    func onLangPickerStateChanged(_ state: LangPickerState) {
        viewModel.updateStateWith(langPickerState: state)
    }

    // MARK: - Private

    private func addLangPicker(_ langPickerBuilder: LangPickerBuilder) {
        langPickerGraph = langPickerBuilder.build()

        guard let langPickerView = langPickerGraph?.uiview else { return }

        view.addSubview(langPickerView)
        langPickerView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(contentView)
        }

        langPickerGraph?.viewmodel.listener = self
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            self?.set(state: state)
        }).disposed(by: disposeBag)
    }

    private func set(state: NewWordState) {
        textField.text = state.text
        sourceLangLabel.text = state.sourceLang.name
        targetLangLabel.text = state.targetLang.name
        langPickerGraph?.viewmodel.state.accept(state.langPickerState)
    }

    private func sendNewWordEventAndDismiss() {
        viewModel.sendNewWord()
        dismiss(animated: true, completion: nil)
    }
}
