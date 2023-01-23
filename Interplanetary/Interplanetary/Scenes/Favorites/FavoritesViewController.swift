//
//  FavoritesViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit

final class FavoritesViewController: BaseViewController {
    
    @IBOutlet private weak var favoritesStationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.favoritesStationsTableView.reloadData()
        }
    }
    
    override func applyStyling() {
        super.applyStyling()
    }
    
    override func syncViewModel() {
        super.syncViewModel()
        
    }
    
    private func configureTableView() {
        favoritesStationsTableView.delegate = self
        favoritesStationsTableView.dataSource = self
        favoritesStationsTableView.registerNib(FavoritesTableViewCell.self)
        favoritesStationsTableView.separatorStyle = .none
        favoritesStationsTableView.tableFooterView = UIView()
    }
}

// MARK: - TableView Delegate & DataSource

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.getFavoriteStations().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station = FavoritesManager.shared.getFavoriteStations()[indexPath.row]
        let cell = tableView.dequeueCell(type: FavoritesTableViewCell.self, indexPath: indexPath)
        let isFavorited = FavoritesManager.shared.isFavorited(with: station)
        cell.configure(with: station, tag: indexPath.row, isFavorited: isFavorited)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - FavoritesTableViewCell Delegate

extension FavoritesViewController: FavoritesTableViewCellDelegate {
    
    func favoritesButtonTapped(tag: Int) {
        let station = FavoritesManager.shared.getFavoriteStations()[tag]
        FavoritesManager.shared.update(with: station)

        favoritesStationsTableView.reloadData()
    }
}
