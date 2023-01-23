//
//  UICollectionView+Extensions.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 22.01.2023.
//

import UIKit

extension UICollectionView {

    public func registerNib(_ type: UICollectionViewCell.Type) {
        register(UINib(nibName: type.identifier, bundle: nil), forCellWithReuseIdentifier: type.identifier)
    }

    public func registerClass(_ type: UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }

    public func dequeueCell<CellType: UICollectionViewCell>(type: CellType.Type, indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            fatalError("Wrong type of cell \(type)")
        }
        return cell
    }
}
