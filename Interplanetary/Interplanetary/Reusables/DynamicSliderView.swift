//
//  DynamicSliderView.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

import UIKit

protocol Slider: AnyObject {
    
    func configure()
    func setTitle(text: String)
}

final class DynamicSlider: UIView {
    
    typealias ValueDidChangeHandler = (Int) -> Void
    public var valueDidChangeHandler: ValueDidChangeHandler?
    
    enum Constants {
        
        static let defaultHeight: CGFloat = 100.0
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.value = 0
        slider.maximumValue = 15
        slider.minimumValue = 0
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        return slider
    }()
    
    private(set) lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel, UIView()])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private(set) lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView, slider])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
}

// MARK: - Configures

extension DynamicSlider: Slider {
    
    func configure() {
        
        self.valueLabel.text = "0"
        
        self.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor).isActive = true
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setMaxValue(value: Int) {
        slider.maximumValue = Float(value)
    }
    
    func reset() {
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 15
        valueLabel.text = "0"
    }
}

// MARK: - Actions

extension DynamicSlider {
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        
        valueDidChangeHandler?(Int(sender.value))
        
        UIView.animate(withDuration: 0.8) {
            self.slider.setValue(sender.value, animated: true)
            self.valueLabel.text = "\(Int(sender.value))"
        }
    }
}

// MARK: - size
extension DynamicSlider {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: Constants.defaultHeight)
    }
}
