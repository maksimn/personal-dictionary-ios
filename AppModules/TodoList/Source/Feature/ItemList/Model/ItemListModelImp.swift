//
//  ItemListModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class ItemListModelImp: ItemListModel {

    var items: [TodoItem] {
        didSet {
            if viewModel == nil {
                viewModel = viewModelBlock()
            }

            viewModel?.items.accept(items)
        }
    }

    private let viewModelBlock: () -> ItemListViewModel?
    private weak var viewModel: ItemListViewModel?
    private weak var delegate: ItemListDelegate?

    init(items: [TodoItem] = [],
         delegate: ItemListDelegate?,
         viewModelBlock: @escaping () -> ItemListViewModel?) {
        self.items = items
        self.delegate = delegate
        self.viewModelBlock = viewModelBlock
    }

    func add(_ todoItem: TodoItem) {
        delegate?.shouldCreate(todoItem: todoItem)
    }

    func toggleCompletionForTodo(at position: Int) {
        guard position > -1 && position < items.count else { return }

        let item = items[position]
        let newItem = item.update(isCompleted: !item.isCompleted)

        delegate?.shouldUpdate(data: UpdatedTodoItemData(newValue: newItem, oldValue: item))
    }

    func remove(at position: Int) {
        guard position > -1 && position < items.count else { return }

        let item = items[position]

        delegate?.shouldDelete(todoItem: item)
    }
}
