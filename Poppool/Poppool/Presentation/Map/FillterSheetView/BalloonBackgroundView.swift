import UIKit

final class BalloonBackgroundView: UIView {
   // MARK: - UI Components
   private let containerView: UIView = {
       let view = UIView()
       view.backgroundColor = .g50
       view.layer.cornerRadius = 8
       return view
   }()

   private let stackView: UIStackView = {
       let stack = UIStackView()
       stack.axis = .vertical
       stack.spacing = 12
       stack.isLayoutMarginsRelativeArrangement = true
       stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
       return stack
   }()

   var arrowPosition: CGFloat = 0.5 {
       didSet {
           setNeedsLayout()
           setNeedsDisplay()
       }
   }

   // MARK: - Properties
   private var selectedRegions: [String] = []
   private var currentSubRegions: [String] = []

   // MARK: - Initialization
   override init(frame: CGRect) {
       super.init(frame: frame)
       backgroundColor = .clear
       setupLayout()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   // MARK: - Setup
   private func setupLayout() {
       addSubview(containerView)
       containerView.addSubview(stackView)

       containerView.snp.makeConstraints { make in
           make.left.right.bottom.equalToSuperview()
           make.top.equalToSuperview().offset(8)
       }

       stackView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
   }

   // MARK: - Drawing
   override func draw(_ rect: CGRect) {
       super.draw(rect)

       let arrowWidth: CGFloat = 12
       let arrowHeight: CGFloat = 8

       let arrowX = bounds.width * arrowPosition - (arrowWidth / 2)
       let path = UIBezierPath()

       path.move(to: CGPoint(x: arrowX, y: 8))
       path.addLine(to: CGPoint(x: arrowX + arrowWidth, y: 8))
       path.addLine(to: CGPoint(x: arrowX + (arrowWidth / 2), y: 0))
       path.close()

       UIColor.g50.set()
       path.fill()
   }

   // MARK: - Public Methods
    func configure(
           with subRegions: [String],
           selectedRegions: [String] = [],
           mainRegionTitle: String,
           selectionHandler: @escaping (String) -> Void,
           allSelectionHandler: @escaping () -> Void  // 전체 선택 핸들러 추가
       ) {
           self.currentSubRegions = subRegions
           self.selectedRegions = selectedRegions

           stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

           // 첫 번째 행에 "전체" 추가
           let firstRow = createChipRow()
           stackView.addArrangedSubview(firstRow)

           let allButton = createButton(
               title: "\(mainRegionTitle)전체",
               isSelected: selectedRegions.count == subRegions.count
           )

           allButton.addAction(
               UIAction { _ in allSelectionHandler() },
               for: .touchUpInside
           )
           firstRow.addArrangedSubview(allButton)

           // 나머지 서브지역 버튼들 추가
           let itemsPerRow = 3
           var currentRow = firstRow
           var currentCount = 1  

           for subRegion in subRegions {
               if currentCount % itemsPerRow == 0 {
                   currentRow = createChipRow()
                   stackView.addArrangedSubview(currentRow)
                   currentCount = 0
               }

               let button = createButton(
                   title: subRegion,
                   isSelected: selectedRegions.contains(subRegion)
               )
               button.addAction(
                   UIAction { _ in selectionHandler(subRegion) },
                   for: .touchUpInside
               )

               currentRow.addArrangedSubview(button)
               currentCount += 1
           }
       }


   private func createButton(title: String, isSelected: Bool) -> PPButton {
       let button = PPButton(
           style: .secondary,
           text: title,
           font: .KorFont(style: .regular, size: 12),
           cornerRadius: 14
       )

       if isSelected {
           button.setBackgroundColor(.blu500, for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.setTitle("\(title) ✓", for: .normal)
           button.layer.borderWidth = 0
       } else {
           button.setBackgroundColor(.white, for: .normal)
           button.setTitleColor(.g200, for: .normal)
           button.layer.borderColor = UIColor.g200.cgColor
           button.layer.borderWidth = 1
       }

       button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
       return button
   }

    private func createChipRow() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually  // 균등 분배로 변경
        stack.alignment = .fill
        return stack
    }

   func updateSelectedRegions(_ regions: [String]) {
       selectedRegions = regions

       stackView.arrangedSubviews.forEach { row in
           guard let stackRow = row as? UIStackView else { return }
           stackRow.arrangedSubviews.forEach { view in
               guard let button = view as? PPButton,
                     let title = button.title(for: .normal)?.replacingOccurrences(of: " ✓", with: "") else { return }

               let isSelected = selectedRegions.contains(title)
               if isSelected {
                   button.setBackgroundColor(.blu500, for: .normal)
                   button.setTitleColor(.white, for: .normal)
                   button.setTitle("\(title) ✓", for: .normal)
                   button.layer.borderWidth = 0
               } else {
                   button.setBackgroundColor(.white, for: .normal)
                   button.setTitleColor(.g200, for: .normal)
                   button.setTitle(title, for: .normal)
                   button.layer.borderColor = UIColor.g200.cgColor
                   button.layer.borderWidth = 1
               }
           }
       }
   }
}
