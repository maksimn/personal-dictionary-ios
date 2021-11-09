//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import Foundation

final class LangPickerModelImpl: LangPickerModel {

    var viewModel: LangPickerViewModel?

    var data: LangSelectorData? = nil {
        didSet {
            guard let data = data else { return }
            viewModel?.langSelectorData = data
        }
    }

    let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func sendSelectedLang(_ lang: Lang) {
        guard let data = data else { return }
        let newData = LangSelectorData(allLangs: data.allLangs, lang: lang, isSourceLang: data.isSourceLang)

        notificationCenter.post(name: .langSelected, object: nil, userInfo: [Notification.Name.langSelected: newData])
    }
}
