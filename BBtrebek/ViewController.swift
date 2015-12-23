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
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let data: NSArray = getNSArrayFromURLEndPoint(url)
        
        self.dataToClue(data)
        self.setClueForCurrentIndex()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        for player in self.players {
            self.view.addSubview(self.playerToUIButton(player))
        }

    }
    
    func handleAwardClueToPlayer(sender: UIButton) {
        print("this was clicked!")
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
            let result: NSArray = getNSArrayFromURLEndPoint(url)
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
            self.scrollView.backgroundColor = UIColor.redColor()
        } else {
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
    
    public func playerToUIButton(player: Player) -> UIButton {
        let playerButton: UIButton = UIButton(frame: CGRectMake(100, 400, 100, 50))
        playerButton.backgroundColor = UIColor.blueColor()
        
        playerButton.setTitle(player.toButtonTitle(),
            forState: UIControlState.Normal
        )
        
        playerButton.addTarget(self,
            action: Selector("handleAwardClueToPlayer:"),
            forControlEvents: UIControlEvents.TouchUpInside
        )
        
        return playerButton
    }
    
    func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }

}

    