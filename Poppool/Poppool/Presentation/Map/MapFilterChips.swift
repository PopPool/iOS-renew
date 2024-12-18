import UIKit
import SnapKit

final class MapFilterChips: UIView {
   // MARK: - Components
   private let stackView: UIStackView = {
       let stack = UIStackView()
       stack.axis = .horizontal
       stack.spacing = 8
       stack.alignment = .fill
       stack.distribution = .fill
       return stack
   }()

   lazy var locationChip = createChipButton(title: "지역선택")
   lazy var categoryChip = createChipButton(title: "카테고리")

   var onRemoveLocation: (() -> Void)?
   var onRemoveCategory: (() -> Void)?

   // MARK: - Init
   init() {
       super.init(frame: .zero)
       setupLayout()
       configureActions()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   // MARK: - Setup
   private func setupLayout() {
       addSubview(stackView)
       stackView.snp.makeConstraints { make in
           make.top.bottom.equalToSuperview()
       }

       stackView.addArrangedSubview(locationChip)
       stackView.addArrangedSubview(categoryChip)
   }

   private func createChipButton(title: String, isSelected: Bool = false) -> UIButton {
       let button = UIButton(type: .system)
       button.setTitle(title, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       button.setTitleColor(isSelected ? .white : .g400, for: .normal)
       button.backgroundColor = isSelected ? .blu500 : .white
       button.layer.cornerRadius = 24
       button.layer.borderWidth = isSelected ? 0 : 1
       button.layer.borderColor = isSelected ? UIColor.blu500.cgColor : UIColor.g200.cgColor
       button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 12)
       return button
   }

   private func configureActions() {
//       locationChip.addTarget(self, action: #selector(locationChipClearTapped), for: .touchUpInside)
//       categoryChip.addTarget(self, action: #selector(categoryChipClearTapped), for: .touchUpInside)
       
   }

   // MARK: - Actions
//   @objc private func locationChipTapped() {
//       onRemoveLocation?()
//   }
//
//   @objc private func categoryChipTapped() {
//       onRemoveCategory?()
//   }

   @objc private func locationChipClearTapped() {
       onRemoveLocation?()
   }

   @objc private func categoryChipClearTapped() {
       onRemoveCategory?()
   }

   // MARK: - Update State
   func update(locationText: String?, categoryText: String?) {
       updateChip(button: locationChip, text: locationText, placeholder: "지역선택")
       updateChip(button: categoryChip, text: categoryText, placeholder: "카테고리")
   }

   private func updateChip(button: UIButton, text: String?, placeholder: String) {
       // 기존 x 버튼 제거
       button.subviews.forEach {
           if $0 is UIButton {
               $0.removeFromSuperview()
           }
       }

       if let text = text, !text.isEmpty, text != placeholder {
           // 선택된 상태
           button.setTitle(text, for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = .blu500
           button.layer.borderWidth = 0
           button.layer.cornerRadius = 24

           // x 버튼 추가
           let xButton = UIButton()
           xButton.setImage(UIImage(named: "icon_xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
           xButton.tintColor = .white
           button.addSubview(xButton)

           xButton.snp.makeConstraints { make in
               make.centerY.equalToSuperview()
               make.trailing.equalToSuperview().inset(12)
               make.size.equalTo(16)
           }

           // x 버튼 터치 이벤트
           if button === locationChip {
               xButton.addTarget(self, action: #selector(locationChipClearTapped), for: .touchUpInside)
           } else {
               xButton.addTarget(self, action: #selector(categoryChipClearTapped), for: .touchUpInside)
           }

           button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 36)
       } else {
           // 기본 상태
           button.setTitle(placeholder, for: .normal)
           button.setTitleColor(.g400, for: .normal)
           button.backgroundColor = .white
           button.layer.borderWidth = 1
           button.layer.borderColor = UIColor.g200.cgColor
           button.layer.cornerRadius = 16
           button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 12)
       }
   }
}
