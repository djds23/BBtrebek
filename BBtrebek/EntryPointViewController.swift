//
//  EntryPointViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let subView = self.createCardView()
        self.view.addSubview(subView)
    }

    public func createCardView() -> CardView {
        let frameWidth = self.view.frame.width
        let frameHeight = self.view.frame.height
        let offsetWidth = 50
        let offsetHeight = 50
        // dummy data
        let clue = Clue(answer: "Coney Island Hot Dog", question: "A favorite food amongst the Detropians, this dish is named after a neighborhood in NYC.", value: 400, airdate: "2008-03-20T12:00:00.000Z", id: 100)
        clue.category = Category(title: "Mismatched Meals", id: 42)
        let cardWidth = frameWidth.subtracting(CGFloat(offsetWidth * 2))
        let cardHeight = frameHeight.subtracting(CGFloat(offsetHeight * 2))
        return CardView.initWithClue(
            clue: clue,
            frame: CGRect(
                origin: CGPoint(x: offsetWidth, y: offsetHeight),
                size: CGSize(width: cardWidth, height: cardHeight)
            )
        )
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
