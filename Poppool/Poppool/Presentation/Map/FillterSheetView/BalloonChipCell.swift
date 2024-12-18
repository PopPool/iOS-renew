import UIKit
import RxSwift

final class BalloonChipCell: UICollectionViewCell {
    static let identifier = "BalloonChipCell"

    private let button: PPButton = {
        let button = PPButton(style: .secondary, text: "", font: .KorFont(style: .regular, size: 12), cornerRadius: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, isSelected: Bool) {
        button.setTitle(title, for: .normal)

        let checkImage = UIImage(named: "icon_check")?.withRenderingMode(.alwaysOriginal)
        button.setImage(isSelected ? checkImage : nil, for: .normal)

        if isSelected {
            button.setBackgroundColor(.blu500, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0
        } else {
            button.setBackgroundColor(.white, for: .normal)
            button.setTitleColor(.g200, for: .normal)
            button.layer.borderColor = UIColor.g200.cgColor
            button.layer.borderWidth = 1
        }
    }

    var buttonAction: (() -> Void)? {
        didSet {
            button.addAction(UIAction { _ in
                self.buttonAction?()
            }, for: .touchUpInside)
        }
    }
}
