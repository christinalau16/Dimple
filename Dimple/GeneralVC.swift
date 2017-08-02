//
//  RandomViewController.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/9/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class GeneralVC: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? CheckboxViewController
        }
    }
}
