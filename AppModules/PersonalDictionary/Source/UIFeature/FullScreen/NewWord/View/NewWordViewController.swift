//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import RxSwift
import UIKit

/// Параметры представления фичи "Добавление нового слова"
struct NewWordViewParams {

    /// Надпись на кнопке "ОК"
    let okText: String

    /// Плейсхолдер для элемента ввода текста слова
    let textFieldPlaceholder: String
}

/// View Controller экрана добавления нового слова в личный словарь.
final class NewWordViewController: UIViewController, UITextFieldDelegate {

    let params: NewWordViewParams
    let theme: Theme
    private let logger: Logger

    private let viewModel: NewWordViewModel

    private var langPickerGraph: LangPickerGraph? // Child Feature

    let contentView = UIView()

    lazy var translationDirectionView = TranslationDirectionView(
        onSourceLangTap: { [weak self] in
            self?.viewModel.presentLangPicker(langType: .source)
        },
        onTargetLangTap: { [weak self] in
            self?.viewModel.presentLangPicker(langType: .target)
        }
    )

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
         langPickerBuilder: LangPickerBuilder,
         theme: Theme,
         logger: Logger) {
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
        logger.log(dismissedFeatureName: "NewWord")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log(installedFeatureName: "NewWord")
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
    func onOkButtonTap() {
        sendNewWordEventAndDismiss()
    }

    // MARK: - Private

    private func addLangPicker(_ langPickerBuilder: LangPickerBuilder) {
        langPickerGraph = langPickerBuilder.build()

        guard let langPickerView = langPickerGraph?.uiview else { return }

        view.addSubview(langPickerView)
        langPickerView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(contentView)
        }

        langPickerGraph?.viewmodel.listener = viewModel

        logger.log(installedFeatureName: "LangPicker")
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            self?.set(state: state)
        }).disposed(by: disposeBag)
    }

    private func set(state: NewWordState) {
        textField.text = state.text
        translationDirectionView.set(sourceLang: state.sourceLang, targetLang: state.targetLang)
        langPickerGraph?.viewmodel.state.accept(state.langPickerState)
    }

    private func sendNewWordEventAndDismiss() {
        viewModel.sendNewWord()
        dismiss(animated: true, completion: nil)
    }
}
