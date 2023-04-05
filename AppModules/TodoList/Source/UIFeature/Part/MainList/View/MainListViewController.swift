//
//  MainListViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Combine
import ComposableArchitecture
import UIKit

struct MainListViewParams {
    let navImage: UIImage
    let dataSourceParams: DataSourceParams
}

final class MainListViewController: UIViewController {

    let params: MainListViewParams
    let theme: Theme

    let tableView = UITableView()
    let navigationButton = UIButton()
    let keyboardController: UIViewController

    lazy var dataSource = DataSource(
        tableView: tableView,
        params: params.dataSourceParams,
        theme: theme,
        onNewTodoTextChanged: { [weak self] text in
            self?.onNewTodoTextChanged(text)
        },
        onDeleteTap: { [weak self] position in
            self?.onDeleteTap(position)
        },
        onTodoCompletionTap: { [weak self] position in
            self?.onTodoCompletionTap(position)
        },
        onDidSelectAt: { [weak self] position in
            self?.onDidSelectAt(position)
        }
    )

    private let store: StoreOf<MainList>
    private let networkIndicatorStore: StoreOf<NetworkIndicator>
    private let viewStore: ViewStoreOf<MainList>
    private var cancellables: Set<AnyCancellable> = []

    init(params: MainListViewParams,
         theme: Theme,
         store: StoreOf<MainList>,
         networkIndicatorStore: StoreOf<NetworkIndicator>,
         keyboardUDFBuilder: ViewControllerBuilder) {
        self.params = params
        self.theme = theme
        self.store = store
        self.networkIndicatorStore = networkIndicatorStore
        self.viewStore = ViewStore(store)
        self.keyboardController = keyboardUDFBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewStore.publisher.sink(receiveValue: { [weak self] state in
            self?.set(state: state)
        }).store(in: &cancellables)

        store.scope(state: \.editor, action: MainList.Action.editor)
            .ifLet(
                then: { [weak self] editorStore in
                    self?.navigateToEditor(editorStore)
                },
                else: { [weak self] in
                    self?.navigationController?.topViewController?.dismiss(animated: true)
                }
            )
            .store(in: &self.cancellables)

        viewStore.send(.loadCachedTodos)
        viewStore.send(.getRemoteTodos)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTableViewLayout(for: viewStore.state.keyboard)
    }

    private func navigateToEditor(_ editorStore: StoreOf<Editor>) {
        let editorBuilder = EditorBuilder(store: editorStore, networkIndicatorStore: networkIndicatorStore)
        let editor = editorBuilder.build()

        navigationController?.topViewController?.present(editor, animated: true, completion: nil)
    }

    @objc
    func navigate() {
        viewStore.send(.editor(.initWith(todo: nil)))
    }

    private func set(state: MainList.State) {
        let todos = state.areCompletedTodosVisible ? state.todos : state.todos.filter { !$0.isCompleted }

        dataSource.update(todos, state.todoText)
        setTableViewLayout(for: state.keyboard)

        if state.keyboard.isVisible {
            tableView.scrollToBottom()
        }
    }

    private func onNewTodoTextChanged(_ text: String) {
        if let enteredCharacter = text.last, enteredCharacter == "\n" {
            let todo = Todo(text: text.trimmingCharacters(in: .whitespacesAndNewlines))

            dataSource.unfocusTextView()
            viewStore.send(.todoTextChanged(""))
            viewStore.send(.keyboard(.hide))
            viewStore.send(.createTodo(todo: todo))
        } else {
            viewStore.send(.todoTextChanged(text))
        }
    }

    private func onDeleteTap(_ position: Int) {
        if let todo = dataSource.todos[safeIndex: position] {
            viewStore.send(.deleteTodo(todo: todo))
        }
    }

    private func onTodoCompletionTap(_ position: Int) {
        if let todo = dataSource.todos[safeIndex: position] {
            viewStore.send(.toggleTodoCompletion(todo: todo))
        }
    }

    private func onDidSelectAt(_ position: Int) {
        if let todo = dataSource.todos[safeIndex: position] {
            viewStore.send(.editor(.initWith(todo: todo)))
        }
    }
}
