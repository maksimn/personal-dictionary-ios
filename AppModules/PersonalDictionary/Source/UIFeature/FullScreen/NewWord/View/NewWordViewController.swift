//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import UDF
import UIKit

/// Параметры представления фичи "Добавление нового слова"
struct NewWordViewParams {

    /// Надпись на кнопке "ОК"
    let okText: String

    /// Плейсхолдер для элемента ввода текста слова
    let textFieldPlaceholder: String
}

/// View Controller экрана добавления нового слова в личный словарь.
final class NewWordViewController: UIViewController, ViewComponent, UITextFieldDelegate {
    
    var props = NewWordState() {
        didSet {
            guard isViewLoaded else { return }

            setViewState(props)
        }
    }
    
    var disposer = Disposer()

    let params: NewWordViewParams
    let theme: Theme
    
    private let store: Store<NewWordState>
    private let newWord: Any
    private let logger: Logger

    let contentView = UIView()

    lazy var translationDirectionView = TranslationDirectionView(
        onSourceLangTap: { [weak self] in
            self?.store.dispatch(LangPickerAction.show(.source))
        },
        onTargetLangTap: { [weak self] in
            self?.store.dispatch(LangPickerAction.show(.target))
        }
    )

    let okButton = UIButton()
    let textField = UITextField()
    
    private var langPickerView: UIView?

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления фичи "Добавление нового слова"
    ///  - viewModel: модель представления.
    ///  - langPickerBuilder: билдер вложенной фичи "Выбор языка"
    init(params: NewWordViewParams,
         store: Store<NewWordState>,
         newWord: Any,
         langPickerBuilder: ViewBuilder,
         theme: Theme,
         logger: Logger) {
        self.params = params
        self.theme = theme
        self.store = store
        self.newWord = newWord
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
        initViews()
        addLangPicker(langPickerBuilder)
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
        store.dispatch(NewWordAction.load)
    }
    
    // MARK: - UITextFieldDelegate

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        store.dispatch(NewWordAction.textChanged(textField.text ?? ""))
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

    private func addLangPicker(_ langPickerBuilder: ViewBuilder) {
        langPickerView = langPickerBuilder.build()

        if let langPickerView {
            view.addSubview(langPickerView)
        }
        
        langPickerView?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(contentView)
        }

        logger.log(installedFeatureName: "LangPicker")
    }

    private func sendNewWordEventAndDismiss() {
        store.dispatch(NewWordAction.sendNewWord)
        dismiss(animated: true, completion: nil)
    }
    
    private func setViewState(_ state: NewWordState) {
        textField.text = state.text
        translationDirectionView.set(sourceLang: state.sourceLang, targetLang: state.targetLang)
        langPickerView?.isHidden = state.langPicker.isHidden
    }
}
