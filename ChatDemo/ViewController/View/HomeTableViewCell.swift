//
//  HomeTableViewCell.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

    var iconImageView = UIImageView()

    var idLabel = UILabel()

    var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.addSubview(iconImageView)
        contentView.addSubview(idLabel)
        contentView.addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(12)
            make.height.width.equalTo(55)
        }

        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(24)
        }
    }
}
