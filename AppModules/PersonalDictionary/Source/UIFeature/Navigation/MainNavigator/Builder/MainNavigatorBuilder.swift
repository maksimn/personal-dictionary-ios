//
//  MainNavigatorBuilder.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

/// Builder of the "Container of Navigation Elements on the Main Screen" feature.
protocol MainNavigatorBuilder {

    /// Create the container.
    /// - Returns: container object.
    func build() -> MainNavigator
}
