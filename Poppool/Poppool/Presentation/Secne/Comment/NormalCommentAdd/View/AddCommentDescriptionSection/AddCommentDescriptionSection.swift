//
//  AddCommentDescriptionSection.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/14/24.
//

import UIKit

import RxSwift

struct AddCommentDescriptionSection: Sectionable {
    
    var currentPage: PublishSubject<Int> = .init()
    
    typealias CellType = AddCommentDescriptionSectionCell
    
    var inputDataList: [CellType.Input]
    
    var supplementaryItems: [any SectionSupplementaryItemable]?
    
    var decorationItems: [any SectionDecorationItemable]?
    
    func setSection(section: Int, env: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 섹션 생성
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}