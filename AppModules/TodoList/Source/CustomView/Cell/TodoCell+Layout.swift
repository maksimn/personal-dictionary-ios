//
//  TodoCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import SnapKit
import UIKit

extension TodoCell {

    func initViews() {
        selectionStyle = .none
        textlabel.backgroundColor = .clear
        textlabel.numberOfLines = 3
        deadlineLabel.font = UIFont.systemFont(ofSize: 15)

        contentView.addSubview(textlabel)
        contentView.addSubview(leadingImageView)
        contentView.addSubview(priorityImageView)
        contentView.addSubview(trailingImageView)
        contentView.addSubview(calendarIconView)
        contentView.addSubview(deadlineLabel)

        setConstraints()
    }

    func setConstraints() {
        leadingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        trailingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.size.equalTo(CGSize(width: 7, height: 12))
        }

        priorityImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.leadingImageView.snp.right).offset(12)
            make.size.equalTo(CGSize(width: 10, height: 16))
        }

        textlabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(16)
            make.left.equalTo(self.priorityImageView.snp.right).offset(8)
            make.right.equalTo(self.trailingImageView.snp.left).offset(-10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
        }

        calendarIconView.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
            make.left.equalTo(self.textlabel.snp.left)
            make.size.equalTo(CGSize(width: 13, height: 12))
        }

        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(self.calendarIconView.snp.top).offset(-2.5)
            make.left.equalTo(self.calendarIconView.snp.right).offset(5)
            make.height.equalTo(18.5)
        }
    }

    func updateLayout(isPriorityHidden: Bool, isDeadlineHidden: Bool) {
        priorityImageView.isHidden = isPriorityHidden
        deadlineLabel.isHidden = isDeadlineHidden
        calendarIconView.isHidden = isDeadlineHidden

        textlabel.snp.updateConstraints { make in
            make.left.equalTo(self.priorityImageView.snp.right).offset(isPriorityHidden ? -8 : 8)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(isDeadlineHidden ? -16 : -34.5)
        }
    }
}
