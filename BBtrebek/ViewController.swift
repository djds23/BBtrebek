//
//  ViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var currentAnswer: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    
    let url = NSURL(string: "http://jservice.io/api/random?count=100")!
    
    var clues: Array<Clue> = [Clue]()
    var trebek: String! = ""
    var currentIndex: Int = 50
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let data: NSArray = self.getClues(url)
        
        self.dataToClue(data)
        self.setClueForCurrentIndex()
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (self.currentIndex <= 0) {
                var data: NSArray = self.getClues(url)
                self.dataToClueRight(data)
            } else {
                self.currentIndex -= 1
            }
        }
        
        if (sender.direction == .Right) {
            if (self.currentIndex >= self.clues.count - 1) {
                let result: NSArray = self.getClues(url)
                self.dataToClue(result)
                self.currentIndex += 1
            
            } else {
                self.currentIndex += 1
            }
        }
        self.setClueForCurrentIndex()
    }
    
    func setClueForCurrentIndex() {
        var currentClue: Clue = self.clues[currentIndex]
        self.currentCategory.text = currentClue.category
        self.currentQuestion.text = currentClue.question
        self.currentAnswer.text = currentClue.answer
        self.currentValue.text = String(currentClue.value)
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
    
    func dataToClue(data: NSArray) {
        for clue in data {
            let category = (clue["category"] as! NSDictionary)["title"] as! String
            
            if let value = clue["value"] as? Int,
                answer = clue["answer"] as? String,
                question = clue["question"] as? String,
                airdate = clue["airdate"] as? String {
                    
                let clueObj = Clue(
                    answer: answer,
                    question: question,
                    value: value,
                    category: category,
                    airdate: airdate
                )
                    
                self.clues.append(clueObj)
            }

        }
    }
    
    func dataToClueRight(data: NSArray) {
        var newClues = [Clue]()
        var oldClues =  self.clues
        for clue in data {
            let category = (clue["category"] as! NSDictionary)["title"] as! String
            
            if let value = clue["value"] as? Int,
                answer = clue["answer"] as? String,
                question = clue["question"] as? String,
                airdate = clue["airdate"] as? String {
    
                let clueObj = Clue(
                    answer: answer,
                    question: question,
                    value: value,
                    category: category,
                    airdate: airdate
                )
                newClues.append(clueObj)
            }
            
        }
        
        self.clues = newClues
        for clue in oldClues {
            self.clues.append(clue)
        }
    }
    
    
}

    