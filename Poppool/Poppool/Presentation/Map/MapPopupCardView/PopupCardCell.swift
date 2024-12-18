import UIKit
import SnapKit

final class PopupCardCell: UICollectionViewCell {
    static let identifier = "PopupCardCell"

    private let imageView = UIImageView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(dateLabel)

        // Image View
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .gray  // Placeholder 색상
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(80)
        }

        // Category Label
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryLabel.textColor = .systemBlue
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        // Address Label
        addressLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addressLabel.textColor = .gray
        addressLabel.numberOfLines = 1
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        // Date Label
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .gray
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }

    // MARK: - Configuration
    func configure(with store: MapPopUpStore) {
        titleLabel.text = store.name
        categoryLabel.text = "#\(store.category)"
        addressLabel.text = store.address
        dateLabel.text = "\(store.startDate) ~ \(store.endDate)"

        // 이미지 로직 (Placeholder 사용)
        imageView.image = UIImage(named: "placeholderImage") // 실제 이미지 로직에 맞게 수정 예정
    }
}
