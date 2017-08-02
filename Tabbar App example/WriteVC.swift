//
//  WriteVC.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/10/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class WriteVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var bgImageView: UIImageView!
    
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
        self.myTextView.delegate = self
        self.myTextView.text = "Channel all the suppressed emotions into words. Write a few sentences on what’s troubling you:"
        self.myTextView.clipsToBounds = true
        self.myTextView.layer.cornerRadius = 10.0
        self.myTextView.layer.borderColor = UIColor.white.cgColor
        self.myTextView.layer.borderWidth = 1.0
        
        self.hideKeyboard() //hides keyboard after writing in myTextView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myTextView.text = "Channel all the suppressed emotions into words. Write a few sentences on what’s troubling you:"
        containerViewController?.helpedButton.awakeFromNib()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.myTextView.text != "Channel all the suppressed emotions into words. Write a few sentences on what’s troubling you:" && self.myTextView.text != ""
        {
            let alertController = UIAlertController(title: nil, message: "Written text will be deleted when you move to the next page", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: { _ in }))
            self.present(alertController, animated: true, completion: nil)
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
    
    //MARK: TextView
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Channel all the suppressed emotions into words. Write a few sentences on what’s troubling you:")
        {
            textView.text = ""
        }
        myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Channel all the suppressed emotions into words. Write a few sentences on what’s troubling you:"
        }
        textView.resignFirstResponder()
    }
    
    //MARK: Keyboard
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as? CheckboxViewController
        }
    }
}

