//
//  EntryPointViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {
// A favorite food amongst the Detropians, this dish is named after a neighborhood in NYC.

    @IBOutlet weak var cardView: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let clue = Clue(answer: "Coney Island Hot Dog", question: "wyhat", value: 400, airdate: "2008-03-20T12:00:00.000Z", id: 100)
        clue.category = Category(title: "Mismatched meals", id: 42)
        self.cardView.setClueLabels(clue: clue)
//        let subView = self.createCardView()
//        self.view.addSubview(subView)
//        self.addAutoLayoutToCard(card: subView)
    }
//
//    public func createCardView() -> CardView {
//        return CardView.initWithClue(clue: clue)
//    }
    
    private func addAutoLayoutToCard(card: CardView) -> Void {
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(
            item: card,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 0
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: card,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 0
        )
        
        let xConstraint = NSLayoutConstraint(
            item: card,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        
        let yConstraint = NSLayoutConstraint(
            item: card,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        
        NSLayoutConstraint.activate([xConstraint, yConstraint, widthConstraint, heightConstraint])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
