//
//  DoubleTitleTableViewCell.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import UIKit
import SnapKit

class DoubleTitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private func configureLayout() {
        
    }
}

