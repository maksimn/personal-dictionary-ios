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

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }

    func dismissLangPicker() {
        langPickerView?.removeFromSuperview()
        langPickerView = nil
    }

    private func sendNewWordEventAndDismiss() {
        viewModel?.sendNewWordEvent()
        dismiss(animated: true, completion: nil)
    }

    private func showLangPickerView(isSourceLang: Bool) {
        guard let allLangs = viewModel?.allLangs,
              let lang = isSourceLang ? viewModel?.sourceLang : viewModel?.targetLang else {
            return
        }
        let langPickerMVVM = LangPickerMVVMImpl(with: LangSelectorData(allLangs: allLangs,
                                                                       lang: lang,
                                                                       isSourceLang: isSourceLang),
                                                notificationCenter: NotificationCenter.default)
        langPickerView = langPickerMVVM.uiview
        view.addSubview(langPickerView ?? UIView())
        langPickerView?.snp.makeConstraints { make -> Void in
            make.edges.equalTo(contentView)
        }
    }
}

// User Action handlers
extension NewWordViewController: UITextFieldDelegate {

    @objc
    func onSourceLangLabelTap() {
        showLangPickerView(isSourceLang: true)
    }

    @objc
    func onTargetLangLabelTap() {
        showLangPickerView(isSourceLang: false)
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
}
