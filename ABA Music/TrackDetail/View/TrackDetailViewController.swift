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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.play()
    }
    
    private func configureUI() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.distribution = .equalSpacing
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        view.addSubview(stackView)
        playerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9 / 16).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -5).isActive = true

        playerView.backgroundColor = UIColor.black
        addLabel(text: track.artistName, size: 20, medium: true, stackView: stackView)
        addLabel(text: track.trackName, size: 18, medium: true, lines: 2, stackView: stackView)
        addLabel(text: track.primaryGenreName, size: 16, stackView: stackView)
        
        let innerStack = UIStackView()
        innerStack.axis = .horizontal
        innerStack.alignment = .fill
        innerStack.distribution = .fillEqually
        stackView.addArrangedSubview(innerStack)
        
        addLabel(text: track.country, size: 12, stackView: innerStack)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        addLabel(text: dateFormatterPrint.string(from: track.releaseDate), size: 12, stackView: innerStack)
        
        view.backgroundColor = UIColor.lightGray
    }

    private func addLabel(text: String, size: CGFloat, medium: Bool = false, lines: Int = 1, stackView: UIStackView) {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: medium ? "HelveticaNeue-Medium" : "HelveticaNeue", size: size)
        label.text = text
        label.numberOfLines = lines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        stackView.addArrangedSubview(label)
    }
}

extension TrackDetailViewController: TrackDetailViewProtocol {
    
    func showTrack(track: Track) {

        self.track = track
        self.playerView = PlayerView()
        self.playerView.prepare(with: URL(string: track.previewUrl)!)
        title = track.trackName
    }
}
