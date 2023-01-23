//
//  UITableView+Extensions.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 22.01.2023.
//

import UIKit

extension UITableView {

    public func registerNib(_ type: UITableViewCell.Type) {
        register(UINib(nibName: type.identifier, bundle: nil), forCellReuseIdentifier: type.identifier)
    }

    public func registerClass(_ type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }

    public func dequeueCell<CellType: UITableViewCell>(type: CellType.Type, indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            fatalError("Wrong type of cell \(type)")
        }
        return cell
    }

    public func dequeueCell<CellType: UITableViewCell>(type: CellType.Type) -> CellType {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.identifier) as? CellType else {
            fatalError("Wrong type of cell \(type)")
        }
        return cell
    }
}
