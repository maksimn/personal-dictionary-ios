//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

struct GlobalSettings {

    let isLoggingEnabled: Bool

    let langData: LangData

    let ponsApiSecret: String

    let viewSettings: GlobalViewSettings
}

struct GlobalViewSettings {

    let appBackgroundColor: UIColor
}
