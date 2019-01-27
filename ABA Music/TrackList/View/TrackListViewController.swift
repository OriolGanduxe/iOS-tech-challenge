//
//  TrackListViewController.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit
import Foundation

class TrackListViewController: UIViewController {
    
    var presenter: TrackListPresenterProtocol!

    var artists: [Artist] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ABA Music"

        setupSearchBar()        
    }
    
    private func setupSearchBar() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artists"
        searchController.searchBar.delegate = self
        searchController.searchBar.text = "Jackson"
        searchController.searchBar.isHidden = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return artists.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistCollectionViewCell
//        cell.artist = artists[indexPath.item]
//        cell.delegate = self
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 180)
//    }
//
//    func didPressTrack(_ track: Track) {
//        let trackViewController = TrackDetailViewController(track: track)
//        navigationController?.pushViewController(trackViewController, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}

extension TrackListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateArtists(query: searchController.searchBar.text!, fetchRemote: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.updateArtists(query: searchBar.text!, fetchRemote: true)
    }
}

extension TrackListViewController: TrackListViewProtocol {
    
    func showArtistTracks(artists: [Artist]) {
        self.artists = artists
        self.tableView.reloadData();
    }
    
    func showError(_ error: Error) {
        // TODO
    }
    
    func loading(enabled: Bool) {
        // TODO
    }

//    func showError() {
//        HUD.flash(.label("Internet not connected"), delay: 2.0)
//    }
//
//    func showLoading() {
//        HUD.show(.progress)
//    }
//
//    func hideLoading() {
//        HUD.hide()
//    }
}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as! ArtistTableViewCell
        
        cell.artist = artists[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension TrackListViewController: ArtistTableViewCellDelegate {
    
    func didPressTrack(_ track: Track, from: UIView) {
        presenter.showTrackDetail(for: track, from: from)
    }
}
