//
//  ConventionTableViewCell.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/26/24.
//

import UIKit

import SnapKit
import RxSwift

final class ConventionTableViewCell: UITableViewCell {
    
    // MARK: - Components
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp, Methods
private extension ConventionTableViewCell {
    func setUpConstraints() {
    }
}

// MARK: - Inputable
extension ConventionTableViewCell: Inputable {
    struct Input {
    }
    
    func injection(with input: Input) {

    }
}
