//
//  ViewController.swift
//  BB

//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit


open class ViewController: UIViewController {

    var rawClues: NSArray?
    var clues: Array<Clue> = []
    var playerGroup: PlayerGroup = PlayerGroup()
    var currentIndex: Int = 0

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var disableCurrentClue: UIButton!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var currentAnswer: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchClues()
        self.addTargetForDisableCurrentClue()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipes(_:)))

        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func handleAwardClueToPlayer(_ sender: PlayerButton) -> Void {
        sender.player.award(clue: self.currentClue())
        sender.setPlayerTitle()
        self.swipeLeft()
    }
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) -> Void {
        if (sender.direction == .right) {
            self.swipeRight()
        }
        if (sender.direction == .left) {
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
             self.fetchClues()
        } else {
            self.currentIndex += 1
        }
        self.setClueForCurrentIndex()
    }
    
    func setClueForCurrentIndex() -> Void {
        let currentClue: Clue = self.currentClue()
        self.currentCategory.text = currentClue.category
        self.currentQuestion.text = currentClue.question
        self.currentAnswer.text = currentClue.answer
        self.currentValue.text = String(currentClue.value)
    }

    func playerToPlayerButton(player: Player) -> UIButton {
        let playerButton: PlayerButton = PlayerButton.initWith(
            player: player,
            frame: CGRect(x: 100, y: 400, width: 100, height: 50)
        )
        
        playerButton.addTarget(self,
            action: #selector(ViewController.handleAwardClueToPlayer(_:)),
            for: UIControlEvents.touchUpInside
        )
        
        return playerButton
    }
    
    func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }
    
    func addTargetForDisableCurrentClue() -> Void {
        self.disableCurrentClue.addTarget(self,
                                          action: #selector(ViewController.disableClue(_:)),
                                          for: UIControlEvents.touchUpInside)
    }
    
    
    open func disableClue(_ sender: AnyObject?) -> Void {
        let clue = self.currentClue()
        DisableClueService(clue: clue).disable(
            success: { disabledClue in
                alert(
                    title: "Disable Question",
                    message:"Clue \(clue.id) was marked disabled.",
                    viewController: self
                )
                self.swipeLeft()
            },
            failure: { (data, urlResponse, error) in
                // If we fail, we fail, should not interrupt game
            }
        )
    }

    func fetchClues() -> Void {
        FetchClueService(count: 500).fetch(
            success: { (newClues) in
                self.clues += newClues
                self.setClueForCurrentIndex()
                for player in self.playerGroup.asArray() {
                    self.view.addSubview(self.playerToPlayerButton(player: player))
                }
            },
            failure: { (data, urlResponse, error) in
                alert(
                    title: "Error Fetching Data!",
                    message: "Trebek was unable to answer in the form of a question, please try again later!",
                    viewController: self
                )
            }
        )
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (sender as? UIButton == self.menuButton) {
            let menuViewController = segue.destination as! MenuViewController
            menuViewController.playerGroup = self.playerGroup
        }
    }
}

    
