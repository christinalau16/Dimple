//
//  DoNothingVC.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/13/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit
import AVFoundation

class DoNothingVC: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    var time = 60
    var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var containerViewController: CheckboxViewController?
    let containerSegueName = "checkboxSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bgImageView.viewWithTag(18) == nil
        {
            //  Mask header image
            let toBeMaskedFrame = CGRect(x: 0, y: 0, width: 1.5 * self.bgImageView.frame.width, height: 1.5 * self.bgImageView.frame.height)
            let maskFrame = self.maskHeaderImageView(frame: toBeMaskedFrame)
            maskFrame.tag = 18
            self.bgImageView.addSubview(maskFrame)
        }
        setNeedsStatusBarAppearanceUpdate()
        
        do
        {
            let audioPath = Bundle.main.path(forResource: "doNothingSong", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            player.numberOfLoops = -1
            player.prepareToPlay()
        }
        catch
        {
            //ERROR
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timerLabel.font = timerLabel.font.withSize(100)
        time = 60
        timerLabel.text = String(time)
        player.currentTime = 0
        containerViewController?.helpedButton.awakeFromNib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer = nil
        player.stop()
    }
    
    func action ()
    {
        time -= 1
        if time == 0
        {
            timer?.invalidate()
            timerLabel.font = timerLabel.font.withSize(50)
            timerLabel.text = "Well done!"
        }
        else
        {
            timerLabel.text = String(time)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        let pageViewController = self.parent as! RootPageViewController
        pageViewController.nextPageWithIndex()
    }
    
    func maskHeaderImageView(frame : CGRect)-> UIView
    {
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.4
        overlayView.backgroundColor = UIColor.black
        
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path;
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? CheckboxViewController
        }
    }
}
