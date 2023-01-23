//
//  HomeViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit

protocol HomeProtocol {
    func setSpaceshipName(with value: String)
    func reloadData()
    func updateDamage()
    func updateTimer(with value: Int)
    func complete()
}

final class HomeViewController: BaseViewController {
    
    /// Constants
    private enum Constants {
        
        enum Styling {
            
            enum Spacing {
                
                static let infosBottom: CGFloat = 24.0
                static let searchBottom: CGFloat = 24.0
            }
            
            enum RemainingUGSLabel {
                
                static let borderWidth: CGFloat = 1.0
                static let borderColor: CGColor = UIColor.black.cgColor
                static let cornerRadius: CGFloat = 1.0
            }
            
            enum CurrentRemainingTimeLabel {
                
                static let borderWidth: CGFloat = 1.0
                static let borderColor: CGColor = UIColor.black.cgColor
                static let cornerRadius: CGFloat = 1.0
            }
            
            enum SearchTextField {
                
                static let borderColor: CGColor = UIColor.black.cgColor
                static let borderWidth: CGFloat = 1.0
                static let cornerRadius: CGFloat = 1.0
                static let leftPadding: CGFloat = 16.0
            }
            
            enum CurrentPlanetNameLabel {
                
                static let font: UIFont = .systemFont(ofSize: 16.0)
                static let textColor: UIColor = .black
                static let textAlignment: NSTextAlignment = .center
                static let numberOfLines: Int = 0
            }
        }
        
        enum Cell {
            
            enum Default {
                
                static let sectionInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
                static let interItemSpacing: CGFloat = 8.0
            }
        }
    }
     
    /// Outlets
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var infosStackView: UIStackView!
    @IBOutlet private weak var spaceshipNameLabel: UILabel!
    @IBOutlet private weak var remainingDamageCapacity: UILabel!
    @IBOutlet private weak var currentRemaininTimeLabel: UILabel!
    @IBOutlet private weak var stationsCollectionView: UICollectionView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchTextContainerView: UIView!
    @IBOutlet private weak var currentPlanetNameLabel: UILabel!
    
    /// Properties
    var viewModel: HomeViewModel?
    private var timer: OTPTimer?
    private var stations: [Station]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureCollectionView()
        configureTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.stationsCollectionView.reloadData()
        }
    }
    
    override func applyStyling() {
        super.applyStyling()
                
        remainingDamageCapacity.layer.borderColor = Constants.Styling.RemainingUGSLabel.borderColor
        remainingDamageCapacity.layer.borderWidth = Constants.Styling.RemainingUGSLabel.borderWidth
        remainingDamageCapacity.layer.cornerRadius = Constants.Styling.RemainingUGSLabel.cornerRadius
        
        currentRemaininTimeLabel.layer.borderColor = Constants.Styling.CurrentRemainingTimeLabel.borderColor
        currentRemaininTimeLabel.layer.borderWidth = Constants.Styling.CurrentRemainingTimeLabel.borderWidth
        currentRemaininTimeLabel.layer.cornerRadius = Constants.Styling.CurrentRemainingTimeLabel.cornerRadius
        
        searchTextField.layer.borderColor = Constants.Styling.SearchTextField.borderColor
        searchTextField.layer.borderWidth = Constants.Styling.SearchTextField.borderWidth
        searchTextField.layer.cornerRadius = Constants.Styling.SearchTextField.cornerRadius
        searchTextField.setLeftPaddingPoints(Constants.Styling.SearchTextField.leftPadding)
        searchTextField.addTarget(self, action: #selector(searchTextValueChanged(_:)), for: .editingChanged)
        
        stackView.setCustomSpacing(Constants.Styling.Spacing.infosBottom, after: infosStackView)
        stackView.setCustomSpacing(Constants.Styling.Spacing.searchBottom, after: searchTextContainerView)
        
        currentPlanetNameLabel.font = Constants.Styling.CurrentPlanetNameLabel.font
        currentPlanetNameLabel.textColor = Constants.Styling.CurrentPlanetNameLabel.textColor
        currentPlanetNameLabel.textAlignment = Constants.Styling.CurrentPlanetNameLabel.textAlignment
        currentPlanetNameLabel.numberOfLines = Constants.Styling.CurrentPlanetNameLabel.numberOfLines
        currentPlanetNameLabel.text = MissionsManager.shared.getCurrentPlanetName()
    }
    
    override func syncViewModel() {
        
        super.syncViewModel()
        
        guard let viewModel = viewModel else { return }
        viewModel.getStationsSuccess = { [weak self] stations in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stations = stations
                self.stationsCollectionView.reloadData()
            }
        }
        
        viewModel.getStationsBySearchCompleted = { [weak self] stations in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stations = stations
                self.stationsCollectionView.reloadData()
            }
        }
        
        viewModel.updateStationsCompleted = { [weak self] stations in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stations = stations
                self.stationsCollectionView.reloadData()
            }
        }
        
        viewModel.missionCompleted = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.complete()
            }
        }
        
        viewModel.fetchStations()
        
        setSpaceshipName(with: viewModel.getSpaceshipName())
        remainingDamageCapacity.text = "\(100)"
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Constants.Cell.Default.sectionInsets
        layout.minimumLineSpacing = Constants.Cell.Default.interItemSpacing
        layout.minimumInteritemSpacing = Constants.Cell.Default.interItemSpacing
        layout.scrollDirection = .horizontal
        stationsCollectionView.collectionViewLayout = layout
        stationsCollectionView.delegate = self
        stationsCollectionView.dataSource = self
        stationsCollectionView.registerNib(HomeStationCollectionViewCell.self)
        stationsCollectionView.backgroundColor = .clear
        stationsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stationsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureTimer() {
        timer?.invalidate()
        timer = OTPTimer(expiredInSeconds: Double(MissionsManager.shared.getCurrentDS()/1000))
        timer?.delegate = self
        timer?.start()
    }
}

// MARK: - Actions

extension HomeViewController {
    
    @objc func searchTextValueChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            DispatchQueue.main.async {
                self.stations = self.viewModel?.getStations()
                self.stationsCollectionView.reloadData()
            }
            return
        }
        viewModel?.getStationsBySearch(with: text)
    }
}

// MARK: - Home Protocol

extension HomeViewController: HomeProtocol {
    
    func setSpaceshipName(with value: String) {
        DispatchQueue.main.async {
            self.spaceshipNameLabel.text = value
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.stationsCollectionView.reloadData()
        }
    }
    
    func updateDamage() {
        DispatchQueue.main.async {
            let damageValue = MissionsManager.shared.getDamageCapacity() - 10
            self.viewModel?.updateDamage(with: damageValue)
            self.remainingDamageCapacity.text = MissionsManager.shared.getDamageCapacity().toString()
        }
    }
    
    func updateTimer(with value: Int) {
        DispatchQueue.main.async {
            self.currentRemaininTimeLabel.text = "\(value.toString())s"
            self.configureTimer()
        }
    }
    
    func complete() {
        DispatchQueue.main.async {
            self.showBasicAlert(with: "Uyarı", message: "Görev Tamamlandı!", style: .alert)
            self.timer?.stop()
        }
    }
}

// MARK: - Timer Delegate

extension HomeViewController: OTPTimerDelegate {
    
    func timerDidFinish() {
        timer?.stop()
        
        viewModel?.checkDamage()
        
        updateTimer(with: 0)
        updateDamage()
    }
    
    func countDown(_ currentValue: Double) {
        currentRemaininTimeLabel.text = "\(String(currentValue.intValue))s"
    }
}

// MARK: - CollectionView Delegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.size.height
        return CGSize(width: width, height: collectionView.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let stations = self.stations else { return 0 }
        return stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: HomeStationCollectionViewCell.self, indexPath: indexPath)
        guard let station = self.stations?[indexPath.row] else { return UICollectionViewCell() }
        let isFavorited = FavoritesManager.shared.isFavorited(with: station)
        cell.configure(with: station,
                       tag: indexPath.row,
                       isFavorited: isFavorited,
                       currentStation: MissionsManager.shared.getCurrentStation())
        cell.delegate = self
        return cell
    }
}

// MARK: - HomeStationCollectionViewCell Delegate

extension HomeViewController: HomeStationCollectionViewCellDelegate {
    
    func favoritesButtonTapped(tag: Int) {
        guard let station = self.stations?[tag] else { return }
        FavoritesManager.shared.update(with: station)
        
        let indexPosition = IndexPath(row: tag, section: 0)
        stationsCollectionView.reloadItems(at: [indexPosition])
    }
    
    func travelButtonTapped(tag: Int, ugs: Int, eus: Int) {
        guard let station = self.stations?[tag] else { return }
        
        viewModel?.updateStation(with: station)
        viewModel?.updateUGS(with: ugs)
        viewModel?.updateEUS(with: eus)
        viewModel?.updateStations()
        
        currentPlanetNameLabel.text = MissionsManager.shared.getCurrentPlanetName()
        configureNavBar()

        viewModel?.checkEUS()
        viewModel?.checkUGS()
    }
}

// MARK: - NavBar

extension HomeViewController {
    
    private func configureNavigationTitleView(ugs: Int, eus: Int, ds: Int) -> UIView {
        lazy var ugsLabel: UILabel = {
            let label =  UILabel(frame: .zero)
            label.text = "UGS: \(ugs)"
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        lazy var eusLabel: UILabel = {
            let label =  UILabel(frame: .zero)
            label.text = "EUS: \(eus)"
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        lazy var dsLabel: UILabel = {
            let label =  UILabel(frame: .zero)
            label.text = "DS: \(ds)"
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [ugsLabel, eusLabel, dsLabel])
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 16
            return stackView
        }()
        
        ugsLabel.translatesAutoresizingMaskIntoConstraints = false
        eusLabel.translatesAutoresizingMaskIntoConstraints = false
        dsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ugsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        eusLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        return stackView
    }
    
    private func configureNavBar() {
        self.navigationItem.titleView = configureNavigationTitleView(ugs: MissionsManager.shared.getCurrentUGS(),
                                                                     eus: MissionsManager.shared.getCurrentEUS(),
                                                                     ds: MissionsManager.shared.getCurrentDS())
    }
}
