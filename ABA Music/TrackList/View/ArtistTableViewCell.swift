import UIKit

protocol ArtistTableViewCellDelegate {
    func didPressTrack(_ track: Track)
}

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ArtistTableViewCellDelegate?
    
    var artist: Artist! {
        didSet {
            artistLabel.text = artist.artistName
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            collectionView.reloadData()
        }
    }
}

extension ArtistTableViewCell: TrackCollectionViewCellDelegate {
    
    func didPressTrack(_ track: Track) {
        delegate?.didPressTrack(track)
    }
}

extension ArtistTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let artist = artist {
            return artist.tracks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as! TrackCollectionViewCell
        cell.track = artist.tracks[indexPath.row]
        cell.delegate = self
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Review this code
        return CGSize(width: collectionView.frame.width * 0.25, height: collectionView.frame.height / 1.5)
    }
}
