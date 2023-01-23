//
//  LandingViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

import UIKit
import CoreLocation

final class LandingViewController: BaseViewController {
    
    /// Constants
    private enum Constants {
        
        enum Styling {
            
            enum TotalPointsLabel {
                
                static let textColor: UIColor = .black
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
        }
        
        enum Calculations {
            
            static let capacityMultiplier: Int = 10000
            static let speedMultiplier: Int = 20
            static let durabilityMultiplier: Int = 10000
        }
        
        enum Error {
            
            static let errorTitle: String = "Hata"
            static let spaceshipNameErrorMessage: String = "Lütfen Uzay Aracına Bir İsim Verin"
            static let emptyFieldErrorMessage: String = "Lütfen 0'dan Farklı Değerler Girin"
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
        totalPointsLabel.textColor = Constants.Styling.TotalPointsLabel.textColor
        totalPointsLabel.font = Constants.Styling.TotalPointsLabel.font
        
        totalPointsLabel.text = "Dağıtılacak Puan: \(Int(viewModel.totalPoints))"
        continueButton.setTitle(Constants.Styling.ContinueButton.title, for: .normal)
    }
    
    override func syncViewModel() {
        
        viewModel.calculatedTotalPointsFull = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.totalPointsLabel.text = "Dağıtılacak Puan: \(Int(self.viewModel.remainingPoints))"
            }
        }
        
        viewModel.calculatedTotalPointsRemainingPoints = { [weak self] remainingPoints in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.totalPointsLabel.text = "Dağıtılacak Puan: \(Int(remainingPoints))"
            }
        }
        
        viewModel.calculatedTotalPointsError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showBasicAlert(with: Constants.Error.errorTitle, message: error, style: .alert)
                self.viewModel.reset()
                
                self.totalPointsLabel.text = "Dağıtılacak Puan: \(Int(self.viewModel.remainingPoints))"
                
                self.speedSliderView.reset()
                self.durabilitySliderView.reset()
                self.capacitySliderView.reset()
            }
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

// MARK: - Actions

extension LandingViewController {
    
    @IBAction func continueButton(_ sender: UIButton) {
        guard let name = nameTextField.text, name.count > 0 else {
            self.showBasicAlert(with: Constants.Error.errorTitle,
                                message: Constants.Error.spaceshipNameErrorMessage, style: .alert)
            return
        }
        
        if viewModel.validateConfiguration() {
            MissionsManager.shared.setSpaceshipName(with: name)
            MissionsManager.shared.setCurrentUGS(with: viewModel.capacity * Constants.Calculations.capacityMultiplier)
            MissionsManager.shared.setCurrentEUS(with: viewModel.speed * Constants.Calculations.speedMultiplier)
            MissionsManager.shared.setCurrentDS(with: viewModel.durability * Constants.Calculations.durabilityMultiplier)
            
            self.navigator.show(scene: .tabs, sender: self, transition: .root(in: Application.shared.window!, animated: false))
        } else {
            self.showBasicAlert(with: Constants.Error.errorTitle,
                                message: Constants.Error.emptyFieldErrorMessage, style: .alert)
        }
    }
}
