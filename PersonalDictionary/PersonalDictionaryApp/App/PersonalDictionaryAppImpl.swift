//
//  PersonalDictionaryAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

final class PersonalDictionaryAppImpl: PersonalDictionaryApp {

    private(set) var navigationController: UINavigationController

    init(configBuilder: ConfigBuilder) {
        let mainWordListBuilder = configBuilder.createMainWordListBuilder()
        let mainWordListGraph = mainWordListBuilder.build()
        navigationController = mainWordListGraph.navigationController ?? UINavigationController()
    }
}
