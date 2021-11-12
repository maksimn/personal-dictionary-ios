//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import Foundation

final class LangPickerModelImpl: LangPickerModel {

    weak var viewModel: LangPickerViewModel?

    private(set) var data: LangSelectorData {
        didSet {
            viewModel?.langSelectorData = data
        }
    }

    private let notificationCenter: NotificationCenter

    init(data: LangSelectorData, notificationCenter: NotificationCenter) {
        self.data = data
        self.notificationCenter = notificationCenter
    }

    func bindInitially() {
        viewModel?.langSelectorData = data
    }

    func sendSelectedLang(_ lang: Lang) {
        let newData = LangSelectorData(allLangs: data.allLangs,
                                       selectedLang: lang,
                                       selectedLangType: data.selectedLangType)

        notificationCenter.post(name: .langSelected, object: nil, userInfo: [Notification.Name.langSelected: newData])
    }
}
