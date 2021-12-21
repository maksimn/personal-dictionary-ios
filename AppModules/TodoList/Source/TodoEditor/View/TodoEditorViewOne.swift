//
//  MyTodoDetailsView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

// Technical debt.
// The code needs to be refactored.
class TodoEditorViewOne: UIViewController {

    var presenter: TodoEditorPresenter?

    private var navBar: TodoEditorNavBar?

    let scrollView = UIScrollView(frame: .zero)
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let pillowView = UIView()
    let separatorViewOne = UIView()
    let separatorViewTwo = UIView()
    let prioritySegmentedControl = UISegmentedControl(items: [Images.lowPriorityMark, Strings.noPriority,
                                                              Images.highPriorityMark])
    let importanceLabel = UILabel()
    let shouldBeDoneBeforeLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let deadlineButton = UIButton()
    let deadlineDatePicker = UIDatePicker()
    let removeButton = UIButton()

    let priorityMapper = TodoItemPriorityMapper()
    let keyboardEventsHandle = KeyboardEventsHandle()

    var isKeyboardActive: Bool = false
    var keyboardSize: CGSize = .zero

    init() {
        super.init(nibName: nil, bundle: nil)
        navBar = TodoEditorNavBar(navigationItem)
        navBar?.onSaveButtonTap = { [weak self] in
            self?.onSaveButtonTap()
        }
        navBar?.onCancelButtonTap = { [weak self] in
            self?.onCancelButtonTap()
        }
        initViews()
        addViews()
        setupWhenNoDataInView()
        initKeyboardEventsHandle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewUpdateActivityIndicator()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrameLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if size.height > size.width {
                self.setPortraitViewVisibilities()
            } else {
                self.setLandscapeViewVisibilities()
            }
        })
    }

    private func setupWhenNoDataInView() {
        deadlineDatePicker.isHidden = true
        separatorViewTwo.isHidden = true
        deadlineButton.isHidden = true
        textView.text = Strings.empty
        prioritySegmentedControl.selectedSegmentIndex = 1
        placeholderLabel.isHidden = false
        deadlineSwitch.setOn(false, animated: false)
        removeButton.setTitleColor(.systemGray, for: .normal)
    }

    private func setDeadlineButtonTitle() {
        deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
    }

    private func unsubscribeAndDismiss() {
        keyboardEventsHandle.unsubscribeFromKeyboardNotifications()
        presenter?.dispose()
        dismiss(animated: true, completion: nil)
    }

    func userInput() -> TodoEditorUserInput {
        let deadline = deadlineSwitch.isOn ? deadlineDatePicker.date : nil
        let priority = priorityMapper.priority(for: prioritySegmentedControl.selectedSegmentIndex)
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        return TodoEditorUserInput(text: trimmedText, priority: priority, deadline: deadline)
    }
}

extension TodoEditorViewOne: TodoEditorView {

    func set(todoItem: TodoItem?) {
        removeButton.setTitleColor(.systemRed, for: .normal)
        textView.text = todoItem?.text
        prioritySegmentedControl.selectedSegmentIndex = priorityMapper.index(for: todoItem?.priority ?? .normal)
        placeholderLabel.isHidden = (todoItem?.text.count ?? 0) > 0

        if let deadline = todoItem?.deadline {
            deadlineSwitch.setOn(true, animated: false)
            deadlineDatePicker.setDate(deadline, animated: false)
            deadlineButton.isHidden = false
            deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
        } else {
            deadlineSwitch.setOn(false, animated: false)
        }
    }

    func setActivityIndicator(visible: Bool) {
        navBar?.setActivityIndicator(visible: visible)
    }

    func setSaveButton(enabled: Bool) {
        navBar?.setSaveButton(enabled)
    }

    var viewController: UIViewController? { self }
}

/// Обработка пользовательских действий (нажатия и т.д.).
extension TodoEditorViewOne: UITextViewDelegate {

    func onCancelButtonTap() {
        unsubscribeAndDismiss()
    }

    func onSaveButtonTap() {
        let input = userInput()

        if presenter?.mode == .editingExisting {
            presenter?.updateTodoItem(input)
        } else {
            let newTodoItem = TodoItem(text: input.text, priority: input.priority, deadline: input.deadline)

            presenter?.create(newTodoItem)
        }

        unsubscribeAndDismiss()
    }

    @objc func onRemoveButtonTap() {
        presenter?.removeTodoItem()
        setupWhenNoDataInView()
        setupFrameLayout()
        unsubscribeAndDismiss()
    }

    @objc func onDeadlineSwitchValueChanged() {
        if deadlineSwitch.isOn {
            deadlineButton.isHidden = false
            setDeadlineButtonTitle()
        } else {
            deadlineButton.isHidden = true
            deadlineDatePicker.isHidden = true
        }
        setupFrameLayout()
        presenter?.onViewInputChanged(userInput())
    }

    @objc func onDeadlineDatePickerValueChanged() {
        setDeadlineButtonTitle()
        presenter?.onViewInputChanged(userInput())
    }

    @objc func onDeadlineButtonTap() {
        deadlineDatePicker.isHidden = !deadlineDatePicker.isHidden
        separatorViewTwo.isHidden = deadlineDatePicker.isHidden
        setupFrameLayout()
    }

    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        let isTextNotEmpty = (text?.count ?? 0) > 0

        placeholderLabel.isHidden = isTextNotEmpty
        removeButton.setTitleColor(isTextNotEmpty ? .systemRed : .systemGray, for: .normal)
        presenter?.onViewInputChanged(userInput())
    }

    @objc func onPriorityChanged() {
        presenter?.onViewInputChanged(userInput())
    }
}
