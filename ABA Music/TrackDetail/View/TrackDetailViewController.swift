//
//  TrackDetailViewController.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

// I decidided to leave this view as it was (with some extra simple changes)
// This was because there's not much data to show, and instead of trying to fill stuff into this view, I made the container smaller so it looks better imo
// I'm aware that by doing this we lose the full screen mode in landscape, but we could easily fix that by adding a button to go full screen regardless the rotation
// Just didn't do it to keep this test simple.

class TrackDetailViewController: UIViewController {
    
    var presenter: TrackDetailPresenterProtocol!

    var track: Track!
    var playerView: PlayerView?
    var missingVideoImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView?.play()
    }
    
    private func configureUI() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.distribution = .equalSpacing
        
        if let playerView = self.playerView {
            configureTopView(topView: playerView, stackView: stackView)
        } else if let missingVideoImageView = self.missingVideoImageView {
            configureTopView(topView: missingVideoImageView, stackView: stackView)
            missingVideoImageView.contentMode = .scaleAspectFill
        }

        addLabel(text: track.artistName, size: 20, medium: true, stackView: stackView)
        addLabel(text: track.trackName, size: 18, medium: true, lines: 2, stackView: stackView)
        addLabel(text: track.primaryGenreName, size: 16, stackView: stackView)
        
        // Added an extra stack view to show the date side by side with the country
        let innerStack = UIStackView()
        innerStack.axis = .horizontal
        innerStack.alignment = .fill
        innerStack.distribution = .fillEqually
        stackView.addArrangedSubview(innerStack)
        
        addLabel(text: track.country, size: 12, stackView: innerStack)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        addLabel(text: dateFormatterPrint.string(from: track.releaseDate), size: 12, stackView: innerStack)
        
        view.backgroundColor = UIColor.darkGray
    }

    private func configureTopView(topView: UIView, stackView: UIStackView) {
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        view.addSubview(stackView)
        topView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 9 / 16).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -5).isActive = true
        topView.backgroundColor = UIColor.black
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
        
        if let previewUrl =  track.previewUrl {
            self.playerView = PlayerView()
            self.playerView!.prepare(with: URL(string: previewUrl)!)
        } else {
            self.missingVideoImageView = UIImageView(image: UIImage(named: "missing_video"))
        }
        title = track.trackName
    }
}
