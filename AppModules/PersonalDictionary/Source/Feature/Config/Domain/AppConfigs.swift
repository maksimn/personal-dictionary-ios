//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

struct AppConfigs {

    let appParams: PersonalDictionaryAppParams

    let langData: LangData

    let ponsApiSecret: String

    let isLoggingEnabled: Bool

    let appViewConfigs: AppViewConfigs
}

struct AppViewConfigs {

    let appBackgroundColor: UIColor
}
