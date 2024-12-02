//
//  BaseViewController.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 8/9/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        Logger.log(
            message: "\(self) init",
            category: .info,
            fileName: #file,
            line: #line
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        Logger.log(
            message: "\(self) deinit",
            category: .info,
            fileName: #file,
            line: #line
        )
    }
}
