//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

final class ConfigBuilderImpl: ConfigBuilder {

    private let appConfigs = ConfigDependencies().appConfigs
    private let superAppRouter: SuperAppRouter?
    private let superAppRoutingButtonTitle: String

    init(superAppRouter: SuperAppRouter?,
         superAppRoutingButtonTitle: String) {
        self.superAppRouter = superAppRouter
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
    }

    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: appConfigs,
                                superAppRouter: superAppRouter,
                                superAppRoutingButtonTitle: superAppRoutingButtonTitle)
    }
}
