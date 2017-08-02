//
//  JokeVC.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/10/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class JokeVC: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var revealButton: UIButton!
    
    let questions = ["What’s brown and sticky?", "What did the 0 say to the 8?", "Why did the storm trooper buy an iPhone?", "Why did the stadium get hot after the game?", "What did the grape say when he was being pinched?", "Which US State has the smallest soft drinks?", "What do you call a fly without wings?"]
    let answers = ["A stick!", "Nice belt!", "He couldn’t find the Droid he was looking for.", "All of the fans left", "Nothing, he gave a little wine.", "Mini-soda", "A walk!"]
    var index = 0
    
    var containerViewController: CheckboxViewController?
    let containerSegueName = "checkboxSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bgImageView.viewWithTag(18) == nil
        {
            let toBeMaskedFrame = CGRect(x: 0, y: 0, width: 1.5 * self.bgImageView.frame.width, height: 1.5 * self.bgImageView.frame.height)
            let maskFrame = self.maskHeaderImageView(frame: toBeMaskedFrame)
            maskFrame.tag = 18
            self.bgImageView.addSubview(maskFrame)
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        index = Int(arc4random_uniform(UInt32(questions.count)))
        questionLabel.text = "Q: \(questions[index])"
        revealButton.setTitle("A: Tap to Reveal", for: .normal)
        setNeedsStatusBarAppearanceUpdate()
        containerViewController?.helpedButton.awakeFromNib()
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
        overlayView.alpha = 0.5
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

    @IBAction func revealPressed(_ sender: UIButton) {
        revealButton.setTitle("A: \(answers[index])", for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? CheckboxViewController
        }
    }
}
