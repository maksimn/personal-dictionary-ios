//
//  EditorViewController+Layout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

extension EditorViewController {

    var pillowViewHeight: CGFloat { 112.5 }
    var textMarginTop: CGFloat { 17 }
    var separatorColor: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.2) }
    var separatorHeight: CGFloat { 0.5 }

    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.addSubview(placeholderLabel)
        scrollView.addSubview(pillowView)
        scrollView.addSubview(separatorViewOne)
        scrollView.addSubview(prioritySegmentedControl)
        scrollView.addSubview(importanceLabel)
        scrollView.addSubview(deadlineTextLabel)
        scrollView.addSubview(deadlineSwitch)
        scrollView.addSubview(deadlineButton)
        scrollView.addSubview(separatorViewTwo)
        scrollView.addSubview(deadlineDatePicker)
        scrollView.addSubview(removeButton)
    }

    func initViews() {
        initNavBar()
        view.backgroundColor = theme.backgroundColor
        scrollView.backgroundColor = theme.backgroundColor
        initTextView()
        initPlaceholderLabel()
        initPillowView()
        initSeparatorView1()
        initSegmentedControl()
        initImportanceLabel()
        initdeadlineTextLabel()
        initDeadlineSwitch()
        initDeadlineLabel()
        initSeparatorView2()
        initDatePicker()
        initRemoveButton()
        addViews()
        add(childViewController: keyboardController)
        addDismissKeyboardOnTapOutsideTextViewGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrameLayout()
    }

    func setupFrameLayout() {
        scrollView.frame = CGRect(x: .zero, y: .zero, width: view.bounds.width, height: view.bounds.height)
        setTextViewFrame()
        placeholderLabel.frame = CGRect(x: textView.frame.minX + 16, y: textView.frame.minY + 17,
                                        width: textView.bounds.width - 33, height: 22)

        let pillowViewWidth = scrollView.bounds.width - 32
        let calendarWidth = pillowViewWidth - 32
        let calendarHeight = calendarWidth * CGFloat(25) / CGFloat(28) + 10

        pillowView.frame = CGRect(x: 16, y: textView.frame.origin.y + textView.frame.size.height + 16,
                                  width: pillowViewWidth,
                                  height: deadlineDatePicker.isHidden ? pillowViewHeight :
                                          pillowViewHeight + calendarHeight)
        separatorViewOne.frame = CGRect(x: pillowView.frame.minX + 16, y: pillowView.frame.origin.y + 56,
                                        width: pillowView.bounds.width - 32, height: separatorHeight)
        prioritySegmentedControl.frame = CGRect(x: scrollView.bounds.width - 150 - 12 - 16,
                                                y: pillowView.frame.origin.y + 10, width: 150, height: 36)
        importanceLabel.frame = CGRect(x: pillowView.frame.origin.x + 16, y: pillowView.frame.origin.y + 17,
                                       width: pillowView.bounds.width - 32, height: 22)
        deadlineTextLabel.frame = CGRect(x: pillowView.frame.origin.x + 16,
                                               y: deadlineSwitch.isOn ? deadlineTextLabelShiftedY :
                                                                        deadlineTextLabelInitY,
                                               width: 160, height: 22)
        deadlineSwitch.frame = CGRect(x: scrollView.bounds.width - 61 - 12 - 16,
                                      y: separatorViewOne.frame.origin.y + separatorHeight + 13.5,
                                      width: 61, height: 31)
        deadlineButton.frame = CGRect(x: pillowView.frame.origin.x + 12.5, y: deadlineTextLabel.frame.maxY - 1.5,
                                      width: 106, height: 18)
        separatorViewTwo.frame = CGRect(x: pillowView.frame.minX + 16, y: separatorViewOne.frame.maxY + 56,
                                        width: pillowView.bounds.width - 32, height: separatorHeight)
        deadlineDatePicker.frame = CGRect(x: pillowView.frame.minX + 16, y: separatorViewTwo.frame.maxY + 12,
                                          width: calendarWidth, height: calendarHeight)
        removeButton.frame = CGRect(x: pillowView.frame.minX,
                                    y: deadlineDatePicker.isHidden ? removeButtonInitY : removeButtonBigY,
                                    width: pillowView.bounds.width, height: 56)

        scrollView.contentSize = CGSize(width: scrollView.bounds.width,
                                        height: removeButton.frame.maxY + 17)
        keyboardController.view.frame = CGRect(x: .zero, y: view.bounds.height - 0.5, width: view.bounds.width,
                                               height: 0.5)
    }

    private func initNavBar() {
        let activityBarButtonItem = UIBarButtonItem(customView: networkIndicatorView)

        navigationItem.title = params.navBarStrings.todo
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItems = [saveBarButtonItem, activityBarButtonItem]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: params.navBarStrings.cancel,
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap)
        )
    }

    private func setTextViewFrame() {
        if viewStore.state.keyboard.orientation == .portrait {
            textView.frame = CGRect(x: 16, y: 16, width: scrollView.bounds.width - 32, height: 120)
        } else {
            let isKeyboardActive = viewStore.state.keyboard.isVisible
            let keyboardSize = viewStore.state.keyboard.size
            let keyboardHeight = isKeyboardActive ? keyboardSize.height : .zero
            let verticalMargins: CGFloat = isKeyboardActive ? 70 : 96
            let horizontalMargins: CGFloat = view.layoutMargins.left + view.layoutMargins.right

            textView.frame = CGRect(x: view.layoutMargins.left, y: 16,
                                    width: scrollView.bounds.width - horizontalMargins,
                                    height: scrollView.bounds.height - verticalMargins - keyboardHeight)
        }
    }

    var removeButtonInitY: CGFloat {
        separatorViewTwo.frame.maxY + 16
    }

    var removeButtonBigY: CGFloat {
        deadlineDatePicker.frame.maxY + 16
    }

    var deadlineTextLabelInitY: CGFloat {
        separatorViewOne.frame.maxY + textMarginTop
    }

    var deadlineTextLabelShiftedY: CGFloat {
        deadlineTextLabelInitY - 6
    }

    private func initTextView() {
        textView.delegate = self
        textView.font = theme.normalFont
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 12, bottom: 17, right: 12)
        textView.contentOffset = CGPoint(x: 0, y: -17)
        textView.backgroundColor = theme.cellColor
        textView.layer.cornerRadius = 16
    }

    private func initPlaceholderLabel() {
        placeholderLabel.text = params.newTodoPlaceholder
        placeholderLabel.font = theme.normalFont
        placeholderLabel.textColor = .lightGray
        placeholderLabel.textAlignment = .left
    }

    private func initPillowView() {
        pillowView.translatesAutoresizingMaskIntoConstraints = false
        pillowView.backgroundColor = theme.cellColor
        pillowView.layer.cornerRadius = 16
    }

    private func initSeparatorView1() {
        separatorViewOne.backgroundColor = separatorColor
    }

    private func initSegmentedControl() {
        prioritySegmentedControl.addTarget(self, action: #selector(onPriorityChanged), for: .valueChanged)
    }

    private func initImportanceLabel() {
        importanceLabel.text = params.priority
        importanceLabel.font = theme.normalFont
    }

    private func initdeadlineTextLabel() {
        deadlineTextLabel.text = params.deadlineText
        deadlineTextLabel.font = theme.normalFont
    }

    private func initDeadlineSwitch() {
        deadlineSwitch.addTarget(self, action: #selector(onDeadlineSwitchValueChanged), for: .valueChanged)
    }

    private func initDeadlineLabel() {
        deadlineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        deadlineButton.setTitleColor(.systemBlue, for: .normal)
        deadlineButton.addTarget(self, action: #selector(onDeadlineButtonTap), for: .touchUpInside)
    }

    private func initSeparatorView2() {
        separatorViewTwo.backgroundColor = separatorColor
    }

    private func initDatePicker() {
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        deadlineDatePicker.setDate(tomorrow, animated: false)
        deadlineDatePicker.addTarget(self, action: #selector(onDeadlineDatePickerValueChanged), for: .valueChanged)
    }

    private func initRemoveButton() {
        removeButton.setTitle(params.remove, for: .normal)
        removeButton.addTarget(self, action: #selector(onRemoveButtonTap), for: .touchUpInside)
        removeButton.titleLabel?.font = theme.normalFont
        removeButton.backgroundColor = theme.cellColor
        removeButton.layer.cornerRadius = 16
    }

    private func addDismissKeyboardOnTapOutsideTextViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        self.view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
}
