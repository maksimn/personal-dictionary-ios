//
//  NewWordViewUIK.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

struct NewWordViewResource {
    let selectButtonTitle: String
    let arrowText: String
    let okText: String
    let textFieldPlaceholder: String
    let backgroundColor: UIColor
}

class NewWordViewController: UIViewController, NewWordView {

    var viewModel: NewWordViewModel?

    let viewResource: NewWordViewResource

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

    init(viewResource: NewWordViewResource) {
        self.viewResource = viewResource
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

    func set(allLangs: [Lang]) {
        releaseLangPickerPopup()

        langPickerPopup = LangPickerPopup(langPickerController: LangPickerController(langs: allLangs),
                                          onSelectLang: self.onSelectLang,
                                          selectButtonTitle: viewResource.selectButtonTitle,
                                          backgroundColor: viewResource.backgroundColor,
                                          isHidden: true)

        layoutLangPickerPopup()
    }

    func set(sourceLang: Lang) {
        sourceLangLabel.text = sourceLang.name
    }

    func set(targetLang: Lang) {
        targetLangLabel.text = targetLang.name
    }
}

// User Action handlers
extension NewWordViewController {

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
        dismiss(animated: true, completion: nil)
    }

    func onSelectLang(_ lang: Lang) {
        langPickerPopup?.isHidden = true

        if isSelectingSourceLang {
            viewModel?.sourceLang = lang
        } else {
            viewModel?.targetLang = lang
        }
    }
}