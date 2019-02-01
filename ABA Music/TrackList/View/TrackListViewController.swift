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
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ABA Music"

        showEmpty()
        setupSearchBar()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // When the app starts, we want it to be come first responder
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    private func setupSearchBar() {
        
        // As there's only one search bar I prefer having this appearance code next to the other searchbar stuff
        // Otherwise this line should go somewhere else with the rest of the general appearance definitions
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artists"
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = false
        searchController.searchBar.tintColor = .white // Cancel button color
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        presenter.viewSizeWillChange(to: size)
    }
}

extension TrackListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateTracks(query: searchController.searchBar.text!, fetchRemote: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.updateTracks(query: searchBar.text!, fetchRemote: true)
    }
}

extension TrackListViewController: TrackListViewProtocol {
    
    func showEmpty() {
        self.feedbackLabel.isHidden = false
        self.feedbackLabel.text = "Search your favourite artists!"
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        
        self.artists = []
        self.tableView.reloadData()
    }
    
    func showArtistTracks(artists: [Artist]) {
        
        self.feedbackLabel.isHidden = true
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        
        self.artists = artists
        self.tableView.reloadData();
    }
    
    func showError(_ error: Error) {

        // For now I have this dummy logic, but we could have strings in the error enum
        // even localising them
        if let error = error as? ArtistsError, error == .emptyArtists {
            self.feedbackLabel.text = "Sorry, we couldn't find any artist with this name"
        } else {
            self.feedbackLabel.text = "Something went wrong, try again later"
        }
        
        self.feedbackLabel.isHidden = false
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        
        self.artists = []
        self.tableView.reloadData()
    }
    
    func loading(enabled: Bool) {
        
        self.feedbackLabel.isHidden = false
        self.feedbackLabel.text = "Loading.."
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        self.artists = []
        self.tableView.reloadData()
    }
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
        if traitCollection.horizontalSizeClass == .compact &&
            artists[indexPath.row].tracks.count >= 10 {
            // Allowing a double row on compact views with lots of tracks
            return 370
        } else {
            return 210
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
}

extension TrackListViewController: ArtistTableViewCellDelegate {
    
    func didPressTrack(_ track: Track) {
        
        // Dismissing the keyboard when the detail shows
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        presenter.showTrackDetail(for: track)
    }
}
