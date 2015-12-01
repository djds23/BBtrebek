//
//  ViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentAnswer: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    
    var clues: NSMutableArray = NSMutableArray()
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        self.prepareLabels()
    
        let url = NSURL(string: "http://jservice.io/api/random?count=100")
        let result: NSArray = self.getClues(url!)
        
        self.dataToClue(result)
        self.setClueForCurrentIndex()
        
        super.viewDidLoad()
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (self.currentIndex <= 0) {
                return
            } else {
                self.currentIndex -= 1
            }
        }
        
        if (sender.direction == .Right) {
            if (self.currentIndex >= self.clues.count - 1) {
                return
            } else {
                self.currentIndex += 1
            }
        }
        self.setClueForCurrentIndex()
    }
    
    func setClueForCurrentIndex() {
        var currentClue: Clue = self.clues[currentIndex] as! Clue
        self.currentCategory.text = currentClue.category
        self.currentQuestion.text = currentClue.question
        self.currentAnswer.text = currentClue.answer
    }
    
    func getClues(url: NSURL) -> NSArray {
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var error: NSError?
        var response: NSURLResponse?
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        error = nil
        let result: NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        return result
    }
    
    func prepareLabels() {
        // These do not work, the whiteColor works, but the text clips on the UILabel
        currentAnswer.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        currentQuestion.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        currentCategory.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        
        currentAnswer.numberOfLines = 0
        currentQuestion.numberOfLines = 4
        currentCategory.numberOfLines = 0
        
        currentAnswer.clipsToBounds = false
        currentQuestion.clipsToBounds = false
        currentCategory.clipsToBounds = false
        
        currentAnswer.textColor = UIColor.whiteColor()
        currentQuestion.textColor = UIColor.whiteColor()
        currentCategory.textColor = UIColor.whiteColor()
    }
    
    func dataToClue(data: NSArray) {
        for clue in data {
            let category = (clue["category"] as! NSDictionary)["title"] as! String
            if let value = clue["value"] as? Int {
                println(clue["question"])
                self.clues.addObject(
                    Clue(
                        answer: clue["answer"] as! String,
                        question: clue["question"] as! String,
                        value: value,
                        category: category,
                        airdate: clue["airdate"] as! String
                    )
                )
            }

        }
    }
}

    