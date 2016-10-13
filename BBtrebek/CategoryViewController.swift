//
//  CategoryViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/13/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class CategoryViewController: UIViewController {

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var currentAnswer: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var backButton: UIButton!

    var gameState: (clues: Array<Clue>, currentIndex: Int, playerGroup: PlayerGroup )?
    var category: Category? = nil
    var clues: Array<Clue> = []
    var currentIndex = 0
    var count = 100
    var offset = 0

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategoryClues(count: count, offset: offset)
        self.addSwipeGestureRecognizers()
    }

    func loadCategoryClues(count: Int, offset: Int) {
        FetchCategoryService(category: self.category!, count: count, offset: offset).fetch(
            success: { (category) in
                self.category = category
                self.clues = category.clues
                self.setClueForCurrentIndex()
            },
            failure: { (data, urlResponse, error) in
                print("failure")
            }
        )
    }

    func addSwipeGestureRecognizers() -> Void {
        let leftSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.handleSwipes(_:))
        )
        let rightSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.handleSwipes(_:))
        )
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
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
        let newIndex = self.currentIndex + 1
        if newIndex % 75 == 0 {
            self.count += 100
            self.offset += 100
            self.loadCategoryClues(count: count, offset: offset)
        }
        if newIndex <= self.clues.count - 1 {
            self.currentIndex = newIndex
            self.setClueForCurrentIndex()
        }
    }
    
    func setClueForCurrentIndex() -> Void {
        let currentClue = self.currentClue()
        self.currentCategory.text = currentClue.categoryTitle()
        self.currentQuestion.text = currentClue.question
        self.currentAnswer.text = currentClue.answer
        self.currentValue.text = String(currentClue.value)
    }
    
    func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton == self.backButton) {
            let gameViewController = segue.destination as! ViewController
            gameViewController.gameState = self.gameState
            gameViewController.clues = (self.gameState?.clues)!
            gameViewController.playerGroup = (self.gameState?.playerGroup)!
            gameViewController.currentIndex = (self.gameState?.currentIndex)!
        }
    }


}
