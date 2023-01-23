//
//  HomeStationCollectionViewCell.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 21.01.2023.
//

import UIKit

protocol HomeStationCollectionViewCellDelegate: AnyObject {
    
    func travelButtonTapped(tag: Int, ugs: Int, eus: Int)
    func favoritesButtonTapped(tag: Int)
}

class HomeStationCollectionViewCell: UICollectionViewCell {
    
    /// Constants
    private enum Constants {
        
        enum Styling {
            
            enum ContainerStackView {
                
                static let borderWidth: CGFloat = 1.0
                static let borderColor: CGColor = UIColor.textColor.cgColor
                static let cornerRadius: CGFloat = 10.0
            }
            
            enum TravelButton {
                
                static let borderWidth: CGFloat = 1.0
                static let borderColor: CGColor = UIColor.textColor.cgColor
                static let cornerRadius: CGFloat = 1.0
                static let title: String = "Travel"
                static let textColor: UIColor = .textColor
            }
            
            enum PlanetLabelName {
                
                static let textColor: UIColor = .textColor
                static let font: UIFont = .systemFont(ofSize: 16.0)
                static let textAlignment: NSTextAlignment = .center
            }
            
            enum StockLabel {
                
                static let textColor: UIColor = .textColor
            }
            
            enum EUSLabel {
                
                static let textColor: UIColor = .textColor
            }
        }
    }
    
    /// Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var planetNameLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var eusLabel: UILabel!
    @IBOutlet private weak var travelButton: UIButton!
    @IBOutlet private weak var favoritesButton: UIButton!

    // Properties
    weak var delegate: HomeStationCollectionViewCellDelegate?
    private var currentStation: Station?
    private var targetStation: Station?
    private var ugs: Int?
    private var eus: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyling()
    }
    
    private func applyStyling() {
        containerStackView.layer.borderWidth = Constants.Styling.ContainerStackView.borderWidth
        containerStackView.layer.borderColor = Constants.Styling.ContainerStackView.borderColor
        containerStackView.layer.cornerRadius = Constants.Styling.ContainerStackView.cornerRadius
        
        travelButton.layer.borderWidth = Constants.Styling.TravelButton.borderWidth
        travelButton.layer.borderColor = Constants.Styling.TravelButton.borderColor
        travelButton.layer.cornerRadius = Constants.Styling.TravelButton.cornerRadius
        travelButton.setTitle(Constants.Styling.TravelButton.title, for: .normal)
        travelButton.setTitleColor(Constants.Styling.TravelButton.textColor, for: .normal)
        
        planetNameLabel.textColor = Constants.Styling.PlanetLabelName.textColor
        planetNameLabel.font = Constants.Styling.PlanetLabelName.font
        planetNameLabel.textAlignment = Constants.Styling.PlanetLabelName.textAlignment
        
        eusLabel.textColor = Constants.Styling.StockLabel.textColor
        
        stockLabel.textColor = Constants.Styling.StockLabel.textColor
    }
    
    func configure(with targetStation: Station, tag: Int, isFavorited: Bool, currentStation: Station) {
        self.targetStation = targetStation
        self.currentStation = currentStation
        
        calculateEUS()
        
        planetNameLabel.text = targetStation.name
        stockLabel.text = "\(targetStation.capacity)/\(targetStation.stock)"
        favoritesButton.tag = tag
        travelButton.tag = tag
        favoritesButton.setImage(UIImage(named: isFavorited ? "favorites-filled" : "favorites-empty"), for: .normal)
    }
}

// MARK: - Actions

extension HomeStationCollectionViewCell {
    
    @IBAction func favoritesButton(_ sender: UIButton) {
        delegate?.favoritesButtonTapped(tag: sender.tag)
    }
    
    @IBAction func travelButton(_ sender: UIButton) {
        guard let targetStation = targetStation,
              let eus = self.eus else { return }
        
        delegate?.travelButtonTapped(tag: sender.tag,
                                     ugs: targetStation.need,
                                     eus: eus)
    }
}

// MARK: - Calculations

extension HomeStationCollectionViewCell {
    
    func calculateEUS() {
        guard let targetStation = targetStation, let currentStation = currentStation else { return }
        
        let result = Utils.CGPointDistanceSquared(from: currentStation.pointXY,
                                                  to: targetStation.pointXY)
        self.eus = Int(result)
        eusLabel.text = "\(result)EUS"
    }
}
