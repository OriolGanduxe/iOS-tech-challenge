//
//  TrackDetailViewController.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {
    
    var presenter: TrackDetailPresenterProtocol!

    var track: Track!
    var playerView: PlayerView!
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        view.addSubview(stackView)
        playerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9 / 16).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10).isActive = true
        playerView.backgroundColor = UIColor.black
        addLabel(text: track.artistName, size: 25)
        addLabel(text: track.trackName, size: 15)
        addLabel(text: track.primaryGenreName, size: 15)
        addLabel(text: track.country, size: 10)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        addLabel(text: dateFormatterPrint.string(from: track.releaseDate), size: 10)

        view.backgroundColor = UIColor.lightGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.play()
    }

    func addLabel(text: String, size: CGFloat) {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Helvetica Neue", size: size)
        label.text = text
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }
}

extension TrackDetailViewController: TrackDetailViewProtocol {
    
    func showTrack(track: Track) {

        self.track = track
        self.stackView = UIStackView()
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.spacing = 10
        self.stackView.distribution = .equalSpacing
        self.playerView = PlayerView()
        self.playerView.prepare(with: URL(string: track.previewUrl)!)
        title = track.trackName
    }
}
