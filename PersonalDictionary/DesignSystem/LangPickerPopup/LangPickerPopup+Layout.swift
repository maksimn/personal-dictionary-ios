//
//  LangPickerPopup+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import SnapKit
import UIKit

extension LangPickerPopup {

    func initViews() {
        addSubview(pickerView)
        addSubview(selectButton)
        initLangPickerView()
        initSelectButton()
    }

    private func initLangPickerView() {
        pickerView.dataSource = langPickerController
        pickerView.delegate = langPickerController
        pickerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 44, right: 16))
        }
    }

    private func initSelectButton() {
        selectButton.setTitle(params.staticContent.selectButtonTitle, for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = .darkGray
        selectButton.layer.cornerRadius = 8
        selectButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        selectButton.addTarget(self, action: #selector(onSelectButtonTap), for: .touchUpInside)
        selectButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-16)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
    }
}
