//
//  MyTodoDetailsView+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

extension TodoEditorViewOne {

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
        scrollView.addSubview(shouldBeDoneBeforeLabel)
        scrollView.addSubview(deadlineSwitch)
        scrollView.addSubview(deadlineButton)
        scrollView.addSubview(separatorViewTwo)
        scrollView.addSubview(deadlineDatePicker)
        scrollView.addSubview(removeButton)
    }

    func initViews() {
        navBar = TodoEditorNavBar(navigationItem, networkIndicatorBuilder)
        navBar?.onSaveButtonTap = { [weak self] in
            self?.onSaveButtonTap()
        }
        navBar?.onCancelButtonTap = { [weak self] in
            self?.onCancelButtonTap()
        }
        view.backgroundColor = Colors.backgroundLightColor
        scrollView.backgroundColor = Colors.backgroundLightColor
        initTextView()
        initPlaceholderLabel()
        initPillowView()
        initSeparatorView1()
        initSegmentedControl()
        initImportanceLabel()
        initShouldBeDoneBeforeLabel()
        initDeadlineSwitch()
        initDeadlineLabel()
        initSeparatorView2()
        initDatePicker()
        initRemoveButton()
        addViews()
        clear()
        initKeyboardEventsHandle()
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
        shouldBeDoneBeforeLabel.frame = CGRect(x: pillowView.frame.origin.x + 16,
                                               y: deadlineSwitch.isOn ? shouldBeDoneBeforeLabelShiftedY :
                                                                        shouldBeDoneBeforeLabelInitY,
                                               width: 160, height: 22)
        deadlineSwitch.frame = CGRect(x: scrollView.bounds.width - 61 - 12 - 16,
                                      y: separatorViewOne.frame.origin.y + separatorHeight + 13.5,
                                      width: 61, height: 31)
        deadlineButton.frame = CGRect(x: pillowView.frame.origin.x + 12.5, y: shouldBeDoneBeforeLabel.frame.maxY - 1.5,
                                      width: 100, height: 18)
        separatorViewTwo.frame = CGRect(x: pillowView.frame.minX + 16, y: separatorViewOne.frame.maxY + 56,
                                        width: pillowView.bounds.width - 32, height: separatorHeight)
        deadlineDatePicker.frame = CGRect(x: pillowView.frame.minX + 16, y: separatorViewTwo.frame.maxY + 12,
                                          width: calendarWidth, height: calendarHeight)
        removeButton.frame = CGRect(x: pillowView.frame.minX,
                                    y: deadlineDatePicker.isHidden ? removeButtonInitY : removeButtonBigY,
                                    width: pillowView.bounds.width, height: 56)

        scrollView.contentSize = CGSize(width: scrollView.bounds.width,
                                        height: removeButton.frame.maxY + 17)
    }

    private func setTextViewFrame() {
        let isPortrait = scrollView.bounds.height > scrollView.bounds.width

        if isPortrait {
            textView.frame = CGRect(x: 16, y: 16, width: scrollView.bounds.width - 32, height: 120)
            scrollView.isScrollEnabled = true
            setPortraitViewVisibilities()
        } else {
            let keyboardHeight = isKeyboardActive ? keyboardSize.height : .zero
            let verticalMargins: CGFloat = isKeyboardActive ? 70 : 96
            let horizontalMargins: CGFloat = view.layoutMargins.left + view.layoutMargins.right

            textView.frame = CGRect(x: view.layoutMargins.left, y: 16,
                                    width: scrollView.bounds.width - horizontalMargins,
                                    height: scrollView.bounds.height - verticalMargins - keyboardHeight)
            scrollView.isScrollEnabled = false
            setLandscapeViewVisibilities()
        }
    }

    var removeButtonInitY: CGFloat {
        separatorViewTwo.frame.maxY + 16
    }

    var removeButtonBigY: CGFloat {
        deadlineDatePicker.frame.maxY + 16
    }

    var shouldBeDoneBeforeLabelInitY: CGFloat {
        separatorViewOne.frame.maxY + textMarginTop
    }

    var shouldBeDoneBeforeLabelShiftedY: CGFloat {
        shouldBeDoneBeforeLabelInitY - 6
    }

    private func initTextView() {
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 12, bottom: 17, right: 12)
        textView.contentOffset = CGPoint(x: 0, y: -17)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 16
    }

    private func initPlaceholderLabel() {
        placeholderLabel.text = Strings.newTodoPlaceholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.textAlignment = .left
    }

    private func initPillowView() {
        pillowView.translatesAutoresizingMaskIntoConstraints = false
        pillowView.backgroundColor = .white
        pillowView.layer.cornerRadius = 16
    }

    private func initSeparatorView1() {
        separatorViewOne.backgroundColor = separatorColor
    }

    private func initSegmentedControl() {
        prioritySegmentedControl.selectedSegmentIndex = 1
        prioritySegmentedControl.addTarget(self, action: #selector(onPriorityChanged), for: .valueChanged)
    }

    private func initImportanceLabel() {
        importanceLabel.text = Strings.priority
        importanceLabel.font = UIFont.systemFont(ofSize: 17)
    }

    private func initShouldBeDoneBeforeLabel() {
        shouldBeDoneBeforeLabel.text = Strings.shouldBeDoneBefore
        shouldBeDoneBeforeLabel.font = UIFont.systemFont(ofSize: 17)
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
        if #available(iOS 14.0, *) {
            deadlineDatePicker.preferredDatePickerStyle = .inline
        }
        deadlineDatePicker.datePickerMode = .date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        deadlineDatePicker.setDate(tomorrow, animated: false)
        deadlineDatePicker.addTarget(self, action: #selector(onDeadlineDatePickerValueChanged), for: .valueChanged)
    }

    private func initRemoveButton() {
        removeButton.setTitle(Strings.remove, for: .normal)
        removeButton.addTarget(self, action: #selector(onRemoveButtonTap), for: .touchUpInside)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        removeButton.setTitleColor(.systemGray, for: .normal)
        removeButton.backgroundColor = .white
        removeButton.layer.cornerRadius = 16
    }

    func setPortraitViewVisibilities() {
        pillowView.isHidden = false
        separatorViewOne.isHidden = false
        prioritySegmentedControl.isHidden = false
        importanceLabel.isHidden = false
        shouldBeDoneBeforeLabel.isHidden = false
        deadlineSwitch.isHidden = false
        deadlineButton.isHidden = false
        removeButton.isHidden = false
    }

    func setLandscapeViewVisibilities() {
        pillowView.isHidden = true
        separatorViewOne.isHidden = true
        prioritySegmentedControl.isHidden = true
        importanceLabel.isHidden = true
        shouldBeDoneBeforeLabel.isHidden = true
        deadlineSwitch.isHidden = true
        deadlineButton.isHidden = true
        removeButton.isHidden = true
    }

    func initKeyboardEventsHandle() {
        keyboardEventsHandle.registerForKeyboardNotifications()
        keyboardEventsHandle.onKeyboardWillHide = self.expandTextViewIfLandscapeAndKeyboardHidden
        keyboardEventsHandle.onKeyboardWillShow = self.minifyTextViewIfLandscapeAndKeyboardShown
    }

    func minifyTextViewIfLandscapeAndKeyboardShown(_ keyboardSize: CGSize) {
        isKeyboardActive = true
        self.keyboardSize = keyboardSize
        setupFrameLayout()
    }

    func expandTextViewIfLandscapeAndKeyboardHidden(_ keyboardSize: CGSize) {
        isKeyboardActive = false
        self.keyboardSize = .zero
        setupFrameLayout()
    }
}
