import UIKit
import SnapKit

final class StoreListView: UIView {

   // MARK: - Components
   private let indicatorView: UIView = {
       let view = UIView()
       view.backgroundColor = .g300
       view.layer.cornerRadius = 2
       return view
   }()

   lazy var collectionView: UICollectionView = {
       let layout = createLayout()
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.backgroundColor = .white
       cv.register(StoreListCell.self, forCellWithReuseIdentifier: StoreListCell.identifier)
       cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
       return cv
   }()

   // MARK: - Init
   init() {
       super.init(frame: .zero)
       setUpConstraints()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}

// MARK: - SetUp
private extension StoreListView {
   func createLayout() -> UICollectionViewFlowLayout {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
       layout.minimumLineSpacing = 24
       layout.minimumInteritemSpacing = 16

       let width = (UIScreen.main.bounds.width - 48) / 2 
       layout.itemSize = CGSize(width: width, height: width + 88)
       return layout
   }

   func setUpConstraints() {
       backgroundColor = .clear  
       layer.cornerRadius = 20
       layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       clipsToBounds = true

       addSubview(indicatorView)
       indicatorView.snp.makeConstraints { make in
           make.top.equalToSuperview().offset(8)
           make.centerX.equalToSuperview()
           make.width.equalTo(40)
           make.height.equalTo(4)
       }

       addSubview(collectionView)
       collectionView.snp.makeConstraints { make in
           make.top.equalTo(indicatorView.snp.bottom).offset(16)
           make.leading.trailing.bottom.equalToSuperview()
       }
   }
}
