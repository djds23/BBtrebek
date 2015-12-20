//
//  ViewController.swift
//  BB

//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit


public class ViewController: UIViewController {

    let url = NSURL(string: "http://jservice.io/api/random?count=100")! // deploy my own and use HTTPS
    var clues: Array<Clue> = [Clue]()
    var players: Array<Player>!
    var currentIndex: Int = 0

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var currentAnswer: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerOneScore: UIButton!
    @IBOutlet weak var playerTwoScore: UIButton!
    
    
    @IBAction func awardPlayerOne(sender: AnyObject) {
        self.currentClue().answered = true
        self.players[0].answeredClues.append(self.currentClue())
        self.swipeLeft()
        
    }
    
    
    @IBAction func awardPlayerTwo(sender: AnyObject) {
        self.currentClue().answered = true
        self.players[1].answeredClues.append(self.currentClue())
        self.swipeLeft()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let data: NSArray = getClues(url)
        
        self.dataToClue(data)
        self.setClueForCurrentIndex()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) -> Void {
        if (sender.direction == .Right) {
            self.swipeRight()
        }
        if (sender.direction == .Left) {
            self.swipeLeft()
        }
    }
    
    func swipeRight() -> Void {
        if (self.currentIndex <= 0) {
            return
        } else {
            self.currentIndex -= 1
        }
        self.setClueForCurrentIndex()
    }
    
    func swipeLeft() -> Void {
        if (self.currentIndex >= self.clues.count - 1) {
            let result: NSArray = getClues(url)
            self.dataToClue(result)
            self.currentIndex += 1
            
        } else {
            self.currentIndex += 1
        }
        self.setClueForCurrentIndex()
    }
    
    func setClueForCurrentIndex() {
        let currentClue: Clue = self.currentClue()
        if (currentClue.answered) {
            self.playerOneScore.setTitle("", forState: .Normal)
            self.playerTwoScore.setTitle("", forState: .Normal)
            self.scrollView.backgroundColor = UIColor.redColor()
        } else {
            self.playerOneScore.setTitle(self.players[0].toButtonTitle(), forState: .Normal)
            self.playerTwoScore.setTitle(self.players[1].toButtonTitle(), forState: .Normal)
            self.scrollView.backgroundColor = UIColor.blueColor()
        }
        self.currentCategory.text = currentClue.category
        self.currentQuestion.text = currentClue.question
        self.currentAnswer.text = currentClue.answer
        self.currentValue.text = String(currentClue.value)
    }
    
    
    func dataToClue(data: NSArray) {
        for clue in data {
            if let clueObj = Clue.initWithNSDictionary(clue as! NSDictionary) {
                self.clues.append(clueObj)
            }
        }
    }
    
    func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }

}

    