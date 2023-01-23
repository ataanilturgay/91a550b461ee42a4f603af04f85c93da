//
//  FavoritesTableViewCell.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 22.01.2023.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    
    func favoritesButtonTapped(tag: Int)
}

class FavoritesTableViewCell: UITableViewCell {
    
    private enum Constants {
        
        enum Styling {
            
            enum PlanetNameLabel {
                
                static let textAlignment: NSTextAlignment = .left
                static let textColor: UIColor = .textColor
            }
            
            enum EUSLabel {
                
                static let textAlignment: NSTextAlignment = .left
                static let textColor: UIColor = .textColor
            }
            
            enum FavoriteButton {
                
                static let filledImage: String = "favorites-filled"
                static let emptyImage: String = "favorites-empty"
                static let tintColor: UIColor = .textColor
            }
        }
    }
    
    @IBOutlet private weak var planetNameLabel: UILabel!
    @IBOutlet private weak var eusLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var delegate: FavoritesTableViewCellDelegate?
    private var station: Station?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with station: Station, tag: Int, isFavorited: Bool) {
        self.station = station
        calculateEUS()
        
        planetNameLabel.text = station.name
        favoriteButton.tag = tag
        favoriteButton.setImage(UIImage(named: isFavorited ? Constants.Styling.FavoriteButton.filledImage : Constants.Styling.FavoriteButton.emptyImage)?.withColor(.textColor), for: .normal)
    }
    
    func applyStyling() {
        self.backgroundColor = .appBackgroundColor
        
        planetNameLabel.textAlignment = Constants.Styling.PlanetNameLabel.textAlignment
        planetNameLabel.textColor = Constants.Styling.PlanetNameLabel.textColor
        
        eusLabel.textAlignment = Constants.Styling.EUSLabel.textAlignment
        eusLabel.textColor = Constants.Styling.EUSLabel.textColor
        
        favoriteButton.tintColor = Constants.Styling.FavoriteButton.tintColor
    }
}

// MARK: - Actions

extension FavoritesTableViewCell {
    
    @IBAction func favoritesButton(_ sender: UIButton) {
        delegate?.favoritesButtonTapped(tag: sender.tag)
    }
}

// MARK: - Calculations

extension FavoritesTableViewCell {
    
    func calculateEUS() {
        
        guard let station = station else { return }
        
        let result = Utils.CGPointDistanceSquared(from: MissionsManager.shared.currentCoordinates(),
                                                  to: station.pointXY)
        eusLabel.text = "\(result)EUS"
    }
}
