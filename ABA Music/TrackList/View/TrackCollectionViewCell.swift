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
           
            let imageURL = URL(string: track!.artworkUrl100)!
            let placeholderImage = UIImage(named: "track_placeholder")
            thumbnailImageView.af_setImage(withURL: imageURL, placeholderImage: placeholderImage)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(pressTrack))
            self.addGestureRecognizer(gesture)
        }
    }
    
    @objc func pressTrack() {
        delegate?.didPressTrack(track!)
    }
}
