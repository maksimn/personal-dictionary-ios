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

    var langPickerView: UIView?

    private let langPickerBuilder: LangPickerBuilder

    init(params: NewWordViewParams,
         langPickerBuilder: LangPickerBuilder) {
        self.params = params
        self.langPickerBuilder = langPickerBuilder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
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

    private func dismissLangPicker() {
        langPickerView?.removeFromSuperview()
        langPickerView = nil
    }

    private func sendNewWordEventAndDismiss() {
        viewModel?.sendNewWordEvent()
        dismiss(animated: true, completion: nil)
    }

    private func showLangPickerView(selectedLangType: SelectedLangType) {
        guard let lang = selectedLangType == .source ? viewModel?.sourceLang : viewModel?.targetLang else { return }
        let langPickerMVVM = langPickerBuilder.build(withInitLang: lang,
                                                     selectedLangType: selectedLangType,
                                                     listener: self)

        langPickerView = langPickerMVVM.uiview
        view.addSubview(langPickerView ?? UIView())
        langPickerView?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(contentView)
        }
    }
}

// User Action handlers
extension NewWordViewController: UITextFieldDelegate, LangPickerListener {

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

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel?.text = textField.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendNewWordEventAndDismiss()
        return true
    }

    func onLangSelected(_ data: LangSelectorData) {
        viewModel?.updateModel(data.selectedLangType, data.selectedLang)
        dismissLangPicker()
    }
}
