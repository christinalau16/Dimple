//
//  RootPageViewController.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/5/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    let formatter = DateFormatter()
    var nextPageIndex = 0
    let vcPageNames = ["Have a joke", "Make tea", "Breathe deeply", "Take a nap", "Stand tall", "Massage your temples", "Drink hot water", "Dance", "Body clench", "Let your feelings out", "Craft", "Eat a banana", "Chew some gum", "Buy a houseplant", "Eat a snack", "Calming scenes", "Listen to music", "Do nothing for 1 minute", "Write", "Watch some comedy", "Have a joke", "Ten minute walk", "Run", "Play a sport", "Take a warm bath", "Naam yoga hand trick"]

    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var instantiatedVC: [UIViewController] = []
        let vcNames = ["jokeVC", "teaVC", "breatheVC", "sleepVC", "standVC", "templesVC", "waterVC", "danceVC", "bodyVC", "feelingsVC", "craftVC", "bananaVC", "gumVC", "plantVC", "eatVC", "imagineVC", "musicVC", "doNothingVC", "writeVC", "comedyVC", "jokeVC", "walkVC", "runVC", "sportVC", "bathVC", "handVC"]
        for vcName in vcNames
        {
            let vc = sb.instantiateViewController(withIdentifier: vcName)
            instantiatedVC.append(vc)
        }
        return instantiatedVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let firstViewController = viewControllerList.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.view.backgroundColor = UIColor.white
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        setCalendarDictionary()
    }

    func nextPageWithIndex () {
        let nextIndex = Int(arc4random_uniform(UInt32(viewControllerList.count)))
        guard viewControllerList.count != nextIndex else {return}
        guard viewControllerList.count > nextIndex else {return}
        setViewControllers([viewControllerList[nextIndex]], direction: .forward, animated: true, completion: nil)
        nextPageIndex = nextIndex
        setCalendarDictionary()
    }
    
    func setCalendarDictionary()
    {

        let currentPageName = vcPageNames[nextPageIndex]
        let currentPage = DatePage(pageName: currentPageName, starred: false)
        currentPage.pageName = currentPageName
        currentPage.starred = false
        
        let userDefaults = UserDefaults.standard
        var savedDictionary: [String: [DatePage]]
        if userDefaults.object(forKey: "calendarData") != nil
        {
            savedDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "calendarData") as! Data) as! [String: [DatePage]]
        } else {
            savedDictionary = [:]
            for i in 1...31
            {
                let createdDate : String
                if i > 0 && i < 10
                {
                    createdDate = "2017 07 0" + String(i)
                } else {
                    createdDate = "2017 07 " + String(i)
                }
                var createdDayArray = [DatePage]()
                var randomNum = Int(arc4random_uniform(25))
                while randomNum > 0 && randomNum < 15 {
                    createdDayArray.append(currentPage)
                    randomNum -= 1
                }
                savedDictionary.updateValue(createdDayArray, forKey: createdDate)
            }
        }
        let userDate = formatter.string(from: Date())
        if let dayArray = savedDictionary[userDate]{
            var copyDayArray = dayArray
            copyDayArray.append(currentPage)
            savedDictionary.updateValue(copyDayArray, forKey: userDate)
        } else {
            savedDictionary.updateValue([currentPage], forKey: userDate)
        }
        
        userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: savedDictionary), forKey: "calendarData")
        userDefaults.synchronize()
    }
}
