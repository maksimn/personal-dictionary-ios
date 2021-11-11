//
//  ConfigGraph.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

protocol ConfigGraph {

    var appConfigs: AppConfigs { get }

    func createMainWordListBuilder() -> MainWordListBuilder
}
