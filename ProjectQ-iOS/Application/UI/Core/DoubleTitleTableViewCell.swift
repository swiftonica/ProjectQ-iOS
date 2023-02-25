//
//  DoubleTitleTableViewCell.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import UIKit

class DoubleTitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

