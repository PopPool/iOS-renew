import UIKit
import SnapKit

final class MapSearchInput: UIView {
    // MARK: - Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()

    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .g900
        return iv
    }()

    private let placeholderLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 14)
        label.text = "팝업스토어명, 지역을 입력해보세요"
        label.textColor = .g400
        return label
    }()

    private let tapButton = UIButton()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension MapSearchInput {
    func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(searchIcon)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(tapButton)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // 높이 제약 조건 제거하여 부모 뷰의 높이에 맞춤
            // make.height.equalTo(48) // 제거
        }

        searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }

        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
