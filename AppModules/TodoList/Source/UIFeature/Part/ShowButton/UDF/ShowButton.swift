//
//  VisibilitySwitch.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

enum ShowButton {

    struct State: Equatable {
        var mode: Mode
        var isEnabled: Bool
    }

    enum Action: Equatable { case toggle }

    enum Mode { case show, hide }
}
