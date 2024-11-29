//
//  HomePopUpCollectionViewCell.swift
//  Poppool
//
//  Created by Porori on 11/27/24.
//

import UIKit
import SnapKit
import RxSwift

struct CellViewModel {
    var item: CellItem
    var type: PopUpCellType
}

struct CellItem {
    let id: Int
    var isBookmarked: Bool
}

enum PopUpCellType {
    case curation
    case popular(rank: Int)
}

final class HomePopUpCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Components
    lazy var containerView = UIView()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lasso")
        imageView.layer.cornerRadius = 4
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        return button
    }()
    
    let rankView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .green
        return view
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 11)
        label.textColor = .blu500
        return label
    }()
    
    let popUpNameLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    var disposeBag = DisposeBag()
    // MARK: - init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: CellItem) {
        let image = item.isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setBackgroundImage(image, for: .normal)
    }
}

// MARK: - SetUp
private extension HomePopUpCollectionViewCell {
    func setUpConstraints() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
        
        containerView.addSubview(popUpNameLabel)
        popUpNameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).inset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpNameLabel.snp.bottom).inset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(17)
        }
        
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        
        imageView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(6)
            make.size.equalTo(24)
        }
        
        imageView.addSubview(rankView)
        rankView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 37, height: 24))
        }
        
        rankView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension HomePopUpCollectionViewCell: Inputable {
    struct Input {
        var image: UIImage?
        var category: String?
        var title: String?
        var location: String?
        var date: String?
        var rank: PopUpCellType
    }
    
    func injection(with input: Input) {
        imageView.image = input.image
        categoryLabel.text = input.category
        popUpNameLabel.text = input.title
        locationLabel.text = input.location
        dateLabel.text = input.date
        
        switch input.rank {
        case .curation:
            rankView.isHidden = true
        case .popular(let rank):
            rankView.isHidden = false
            rankLabel.text = "\(rank)위"
        }
    }
}
