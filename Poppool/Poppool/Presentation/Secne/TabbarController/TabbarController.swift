//
//  TabbarController.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/1/24.
//

import UIKit

class WaveTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let waveLayer = CAShapeLayer()
    
    private let dotView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.6
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .blu500
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaveTabBar()
        setUp()
        addSomeTabItems()
        delegate = self
    }
    
    private func setupWaveTabBar() {
        // TabBar의 배경 투명 설정
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        
        // Wave Layer 설정
        waveLayer.fillColor = UIColor.white.cgColor
        tabBar.layer.insertSublayer(waveLayer, at: 0)
        
        // Dot 설정
        dotView.frame.size = CGSize(width: 12, height: 12)
        dotView.layer.cornerRadius = 6
        tabBar.addSubview(dotView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateWavePath()
        updateDotPosition(animated: false)
        
    }
    
    private func updateWavePath() {
        guard let items = tabBar.items else { return }
        let tabWidth = tabBar.bounds.width / CGFloat(items.count)
        let selectedTabX = CGFloat(selectedIndex) * tabWidth
        let waveHeight: CGFloat = 12
        let waveWidth: CGFloat = 24
        let leftPoint = selectedTabX + tabWidth / 2 - waveWidth / 2
        let cornerRadius: CGFloat = 12  // 둥근 코너 반지름
        let path = UIBezierPath()

        // 시작점 - 왼쪽 둥근 부분
        path.move(to: CGPoint(x: 0, y: -waveHeight))
        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: -waveHeight + cornerRadius),
            radius: cornerRadius,
            startAngle: .pi, // 왼쪽 상단 180도
            endAngle: .pi * 1.5, // 왼쪽 하단 270도
            clockwise: true
        )

        // 왼쪽 끝과 중앙을 부드럽게 연결 (라운드 처리)
        path.addLine(to: CGPoint(x: leftPoint, y: -waveHeight))
        path.addArc(
            withCenter: CGPoint(x: selectedTabX + tabWidth / 2, y: -waveHeight),
            radius: 12,
            startAngle: .pi, // 왼쪽 180도
            endAngle: .pi * 2, // 오른쪽 0도
            clockwise: false
        )

        // 오른쪽 끝과 중앙을 부드럽게 연결 (라운드 처리)
        path.addLine(to: CGPoint(x: tabBar.bounds.width - cornerRadius, y: -waveHeight))

        // 오른쪽 둥근 부분
        path.addArc(
            withCenter: CGPoint(x: tabBar.bounds.width - cornerRadius, y: -waveHeight + cornerRadius),
            radius: cornerRadius,
            startAngle: .pi * 1.5, // 오른쪽 하단 270도
            endAngle: 0, // 오른쪽 상단 0도
            clockwise: true
        )

        // TabBar 하단을 덮는 직선
        path.addLine(to: CGPoint(x: tabBar.bounds.width, y: tabBar.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: tabBar.bounds.height))
        path.close()

        waveLayer.path = path.cgPath
    }




    
    private func updateDotPosition(animated: Bool) {
        guard let items = tabBar.items else { return }
        let tabWidth = tabBar.bounds.width / CGFloat(items.count)
        let selectedTabX = CGFloat(selectedIndex) * tabWidth
        
        let targetCenter = CGPoint(
            x: selectedTabX + tabWidth / 2,
            y: -12
        )
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.dotView.center = targetCenter
            })
        } else {
            dotView.center = targetCenter
        }
    }
    
    // 탭 선택 시 애니메이션 적용
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateWavePath()
        updateDotPosition(animated: true)
    }
    
    func setUp() {
        self.selectedIndex = 0
        self.tabBar.barTintColor = .g200
        self.tabBar.tintColor = .blu500
    }
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    func addSomeTabItems() {
        let mapController = BaseViewController()
        
        let homeController = HomeController()
        homeController.reactor = HomeReactor()
        
        let myPageController = BaseViewController()
        
        let iconSize = CGSize(width: 36, height: 36)
        // 탭바 아이템 생성
        mapController.tabBarItem = UITabBarItem(
            title: "지도",
            image: resizeImage(image: UIImage(named: "icon_tabbar_map"), targetSize: iconSize),
            selectedImage: resizeImage(image: UIImage(named: "icon_tabbar_map"), targetSize: iconSize)
        )
        homeController.tabBarItem = UITabBarItem(
            title: "홈",
            image: resizeImage(image: UIImage(named: "icon_tabbar_home"), targetSize: iconSize),
            selectedImage: resizeImage(image: UIImage(named: "icon_tabbar_home"), targetSize: iconSize)
        )
        myPageController.tabBarItem = UITabBarItem(
            title: "마이",
            image: resizeImage(image: UIImage(named: "icon_tabbar_menu"), targetSize: iconSize),
            selectedImage: resizeImage(image: UIImage(named: "icon_tabbar_menu"), targetSize: iconSize)
        )
        
        // 네비게이션 컨트롤러 설정
        let village = UINavigationController(rootViewController: mapController)
        let community = UINavigationController(rootViewController: homeController)
        let store = UINavigationController(rootViewController: myPageController)
        
        viewControllers = [village, community, store]
        
        // 폰트 설정
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes(
                    [.font: UIFont.KorFont(style: .bold, size: 11)!],
                    for: .normal
                )
                item.setTitleTextAttributes(
                    [.font: UIFont.KorFont(style: .bold, size: 11)!],
                    for: .selected
                )
            }
        }
    }
}
