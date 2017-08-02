//
//  ImagineVC.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/15/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ImagineVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    var player:AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    let filepaths = ["lighthouseVideo", "riverVideo", "blossomVideo", "snowVideo", "fieldVideo"]
    let filePathImages = [#imageLiteral(resourceName: "iconLighthouse"), #imageLiteral(resourceName: "iconRiver"), #imageLiteral(resourceName: "iconBlossom"), #imageLiteral(resourceName: "iconSnow"), #imageLiteral(resourceName: "iconField")]
    
    var containerViewController: CheckboxViewController?
    let containerSegueName = "checkboxSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        playVideo(videoString: filepaths.first!)
        self.iconCollectionView.delegate = self
        self.iconCollectionView.dataSource = self
        self.iconCollectionView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player.seek(to: kCMTimeZero)
        containerViewController?.helpedButton.awakeFromNib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.textColor = UIColor.black
        nextButton.setTitleColor(.black, for: .normal)
        playVideo(videoString: filepaths.first!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player.pause()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        let pageViewController = self.parent as! RootPageViewController
        pageViewController.nextPageWithIndex()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filepaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagineCell", for: indexPath) as! ImagineCollectionViewCell
        cell.layer.cornerRadius = 25
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        cell.cellImageView.image = filePathImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playVideo(videoString: filepaths[indexPath.row])
        if (indexPath.row == 0 || indexPath.row == 3)
        {
            titleLabel.textColor = UIColor.black
            nextButton.setTitleColor(.black, for: .normal)
        }
        else
        {
            titleLabel.textColor = UIColor.white
            nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        let cellCount = CGFloat(filepaths.count)
        
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            let totalCellWidth = cellWidth*cellCount
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
    
    private func playVideo(videoString: String) {
        playerLayer.removeFromSuperlayer()
        if let filePath = Bundle.main.path(forResource: videoString, ofType: ".mp4") {
            let filePathURL = NSURL.fileURL(withPath: filePath)
            player = AVPlayer(url: filePathURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.videoView.layer.addSublayer(playerLayer)
            player.play()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? CheckboxViewController
        }
    }
}
