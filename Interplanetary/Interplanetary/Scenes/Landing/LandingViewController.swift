//
//  LandingViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

import UIKit
import CoreLocation

protocol LandingViewProtocol: AnyObject {
    
    func updateTotalPointsLabel(with value: Int)
}

final class LandingViewController: BaseViewController {
    
    /// Constants
    private enum Constants {
        
        enum Styling {
            
            enum TotalPointsLabel {
                
                static let textColor: UIColor = .textColor
                static let font: UIFont = .systemFont(ofSize: 16.0)
            }
            
            enum DurabilitySliderView {
                
                static let title: String = "Dayanıklılık -> "
            }
            
            enum SpeedSliderView {
                
                static let title: String = "Hız -> "
            }
            
            enum CapacitySliderView {
                
                static let title: String = "Kapasite -> "
            }
            
            enum ContinueButton {
                
                static let title: String = "Devam Et"
            }
            
            enum NameTextField {
                
                static let placeholder: String = "Uzay Aracı İsmi Girin..."
                static let textColor: UIColor = .textColor
                static let font: UIFont = .systemFont(ofSize: 16.0)
                static let leftPadding: CGFloat = 16.0
                static let borderWidth: CGFloat = 1.0
                static let borderColor: CGColor = UIColor.textColor.cgColor
            }
        }
        
        enum Error {
            
            static let errorTitle: String = "Hata"
        }
    }
    
    /// Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var durabilitySliderView: DynamicSlider!
    @IBOutlet private weak var speedSliderView: DynamicSlider!
    @IBOutlet private weak var capacitySliderView: DynamicSlider!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var totalPointsLabel: UILabel!
    
    private lazy var viewModel = {
       return LandingViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncViewModel()
        configureSliders()
    }
    
    override func applyStyling() {
        
        self.view.backgroundColor = .appBackgroundColor
        
        totalPointsLabel.textColor = Constants.Styling.TotalPointsLabel.textColor
        totalPointsLabel.font = Constants.Styling.TotalPointsLabel.font
        totalPointsLabel.text = "Dağıtılacak Puan: \(Int(viewModel.totalPoints))"
        
        nameTextField.placeholder = Constants.Styling.NameTextField.placeholder
        nameTextField.textColor = Constants.Styling.NameTextField.textColor
        nameTextField.font = Constants.Styling.NameTextField.font
        nameTextField.setLeftPaddingPoints(Constants.Styling.NameTextField.leftPadding)
        nameTextField.layer.borderWidth = Constants.Styling.NameTextField.borderWidth
        nameTextField.layer.borderColor = Constants.Styling.NameTextField.borderColor
        
        continueButton.setTitle(Constants.Styling.ContinueButton.title, for: .normal)
        continueButton.backgroundColor = .textColor
        continueButton.setTitleColor(.appBackgroundColor, for: .normal)
    }
    
    override func syncViewModel() {
        viewModel.calculatedTotalPointsSuccess = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateTotalPointsLabel(with: self.viewModel.getRemainingPoints())
            }
        }
        
        viewModel.calculatedTotalPointsRemainingPoints = { [weak self] remainingPoints in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateTotalPointsLabel(with: self.viewModel.getRemainingPoints())
            }
        }
        
        viewModel.calculatedTotalPointsError = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showBasicAlert(with: Constants.Error.errorTitle, message: "Toplam Dağıtılan Puan 15 Olmalı!", style: .alert)
                self.viewModel.reset()
                
                self.updateTotalPointsLabel(with: self.viewModel.getRemainingPoints())

                self.speedSliderView.reset()
                self.durabilitySliderView.reset()
                self.capacitySliderView.reset()
            }
        }
        
        viewModel.validationSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.navigator.show(scene: .tabs,
                                sender: self,
                                transition: .root(in: Application.shared.window!,
                                                  animated: false))
        }
        
        viewModel.validationError = { [weak self] error in
            guard let self = self else { return }

            self.showBasicAlert(with: "Hata",
                                message: error.errorMessage,
                                style: .alert)
        }
    }
}

// MARK: - Configures

extension LandingViewController {
    
    private func configureSliders() {
        durabilitySliderView.configure()
        durabilitySliderView.setTitle(text: Constants.Styling.DurabilitySliderView.title)
        durabilitySliderView.valueDidChangeHandler = { [weak self] value in
            guard let self = self else { return }
            self.viewModel.durability = value
            self.viewModel.calculateTotalPoints()
            
            if self.viewModel.checkSlidersEnable() {
                if self.viewModel.speed == 0 {
                    self.speedSliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
                if self.viewModel.capacity == 0 {
                    self.capacitySliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
            }
        }
        
        speedSliderView.configure()
        speedSliderView.setTitle(text: Constants.Styling.SpeedSliderView.title)
        speedSliderView.valueDidChangeHandler = { [weak self] value in
            guard let self = self else { return }
            self.viewModel.speed = value
            self.viewModel.calculateTotalPoints()
            
            if self.viewModel.checkSlidersEnable() {
                if self.viewModel.durability == 0 {
                    self.durabilitySliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
                if self.viewModel.capacity == 0 {
                    self.capacitySliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
            }
        }
        
        capacitySliderView.configure()
        capacitySliderView.setTitle(text: Constants.Styling.CapacitySliderView.title)
        capacitySliderView.valueDidChangeHandler = { [weak self] value in
            guard let self = self else { return }
            self.viewModel.capacity = value
            self.viewModel.calculateTotalPoints()
            
            if self.viewModel.checkSlidersEnable() {
                if self.viewModel.speed == 0 {
                    self.speedSliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
                if self.viewModel.durability == 0 {
                    self.durabilitySliderView.setMaxValue(value: self.viewModel.remainingPoints)
                }
            }
        }
    }
}

// MARK: - LandingView Protocol

extension LandingViewController: LandingViewProtocol {
    
    func updateTotalPointsLabel(with value: Int) {
        totalPointsLabel.text = "Dağıtılacak Puan: \(value)"
    }
}

// MARK: - Actions

extension LandingViewController {
    
    @IBAction func continueButton(_ sender: UIButton) {
        viewModel.spaceshipName = nameTextField.text
        viewModel.validate()
    }
}
