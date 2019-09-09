//
//  PlayersWaitingTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/16/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PlayersWaitingTableViewCell: UITableViewCell {
    
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellGray
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = false
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    var rowNumberLabel = UIElementsManager.createLabel(with: "", fontSize: 19, textAlignment: .center, isHeader: true)

    var usernameLabel = UIElementsManager.createLabel(with: "", fontSize: 16, color: .textGray)
    
    var pencilImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Pencil")
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .primaryWhite
        selectionStyle = .none
        
        addSubview(cellBackgroundView)
        cellBackgroundView.addSubviews(rowNumberLabel, usernameLabel, pencilImageView)
        setupConstraints()
    }
    
    func configure(username: String, index: Int, isCurrentUsername: Bool) -> String {
        rowNumberLabel.text = String(index)
        pencilImageView.isHidden = true
        pencilImageView.isUserInteractionEnabled = false
        if isCurrentUsername {
            if usernameLabel.text == "" { usernameLabel.text = username }
            pencilImageView.isHidden = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeUsername))
            pencilImageView.addGestureRecognizer(tapGesture)
            pencilImageView.isUserInteractionEnabled = true
            NotificationCenter.default.addObserver(self, selector: #selector(disableUsernameInteraction), name: .editingOver, object: nil)
            return usernameLabel.text!
        } else {
            usernameLabel.text = username
            return username
        }

    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            
            rowNumberLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 24),
            rowNumberLabel.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: rowNumberLabel.trailingAnchor, constant: 18),
            usernameLabel.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor),
            
            pencilImageView.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor),
            pencilImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pencilImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.pencilHeightAndWidth),
            pencilImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.pencilHeightAndWidth)
            
            ])

    }
    
    @objc func changeUsername() {
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.becomeFirstResponder()
    }
    
    @objc func disableUsernameInteraction() {
        usernameLabel.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
