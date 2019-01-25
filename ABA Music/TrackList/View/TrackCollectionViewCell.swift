import UIKit
import AlamofireImage

protocol TrackCollectionViewCellDelegate {
    func didPressTrack(_ track: Track)
}

class TrackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var delegate: TrackCollectionViewCellDelegate?
    
    var track: Track! {
        didSet {
            trackNameLabel.text = track.trackName
            thumbnailImageView.af_setImage(withURL: URL(string: track!.artworkUrl100)!)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(pressTrack))
            self.addGestureRecognizer(gesture)
        }
    }
    
    @objc func pressTrack() {
        delegate?.didPressTrack(track!)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        thumbnailImageView.layer.cornerRadius = 5
        thumbnailImageView.clipsToBounds = true
    }
}
