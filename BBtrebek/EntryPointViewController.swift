//
//  EntryPointViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {

    var clues: Array<Clue> = []
    var currentIndex: Int = 0
    
    @IBOutlet weak var cardView: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchClues()
        let clue = Clue(
            answer: "Coney Island Hot Dog",
            question: "A favorite food amongst the Detropians, this dish is named after a neighborhood in NYC.",
            value: 400,
            airdate: "2008-03-20T12:00:00.000Z",
            id: 100
        )
        clue.category = Category(title: "Mismatched meals", id: 42)
        clues.append(clue)
        self.cardView.setClueLabels(clue: self.currentClue())
        self.addSwipeGestureRecognizers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func addSwipeGestureRecognizers() -> Void {
        let leftSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(EntryPointViewController.handleSwipes(_:))
        )
        let rightSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(EntryPointViewController.handleSwipes(_:))
        )
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.cardView.addGestureRecognizer(leftSwipe)
        self.cardView.addGestureRecognizer(rightSwipe)
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
        let currentClue = self.currentClue()
        self.cardView.setClueLabels(clue: currentClue)
    }
    
    
    func fetchClues() -> Void {
        FetchClueService(count: 500).fetch(
            success: { (newClues) in
                // it is possible the server sent duplicates back, make sure to de-dup this list
                self.clues += newClues
                self.setClueForCurrentIndex()
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

    func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
