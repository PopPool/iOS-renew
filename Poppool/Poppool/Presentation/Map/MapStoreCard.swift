import UIKit
import SnapKit

final class MapStoreCard: UIView {
   // MARK: - Components
   private let containerView: UIView = {
       let view = UIView()
       view.backgroundColor = .white
       view.layer.cornerRadius = 16
       view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       view.layer.shadowColor = UIColor.black.cgColor
       view.layer.shadowOpacity = 0.1
       view.layer.shadowRadius = 4
       view.layer.shadowOffset = CGSize(width: 0, height: -2)
       return view
   }()

   private let thumbnailImageView: UIImageView = {
       let iv = UIImageView()
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       iv.layer.cornerRadius = 8
       return iv
   }()

   private let categoryLabel = PPLabel(style: .regular, fontSize: 12)
   private let titleLabel = PPLabel(style: .bold, fontSize: 16)
   private let locationLabel = PPLabel(style: .regular, fontSize: 12)
   private let dateLabel = PPLabel(style: .regular, fontSize: 12)

   // MARK: - Init
   init() {
       super.init(frame: .zero)
       setupLayout()
       configureUI()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}

// MARK: - Setup
private extension MapStoreCard {
   func setupLayout() {
       addSubview(containerView)

       [thumbnailImageView, categoryLabel, titleLabel, locationLabel, dateLabel].forEach {
           containerView.addSubview($0)
       }

       containerView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }

       thumbnailImageView.snp.makeConstraints { make in
           make.leading.equalToSuperview().offset(16)
           make.centerY.equalToSuperview()
           make.size.equalTo(80)
       }

       categoryLabel.snp.makeConstraints { make in
           make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
           make.top.equalToSuperview().offset(20)
       }

       titleLabel.snp.makeConstraints { make in
           make.leading.equalTo(categoryLabel)
           make.top.equalTo(categoryLabel.snp.bottom).offset(4)
           make.trailing.equalToSuperview().inset(16)
       }

       locationLabel.snp.makeConstraints { make in
           make.leading.equalTo(categoryLabel)
           make.top.equalTo(titleLabel.snp.bottom).offset(4)
       }

       dateLabel.snp.makeConstraints { make in
           make.leading.equalTo(locationLabel.snp.trailing).offset(8)
           make.centerY.equalTo(locationLabel)
       }
   }

   func configureUI() {
       categoryLabel.textColor = .g700
       locationLabel.textColor = .g500
       dateLabel.textColor = .g500
   }
}

// MARK: - Inputable
extension MapStoreCard: Inputable {
   struct Input {
       let image: UIImage?
       let category: String
       let title: String
       let location: String
       let date: String
   }

   func injection(with input: Input) {
       thumbnailImageView.image = input.image ?? UIImage(named: "default_thumbnail")
       categoryLabel.text = input.category
       titleLabel.text = input.title
       locationLabel.text = input.location
       dateLabel.text = input.date
   }
}
