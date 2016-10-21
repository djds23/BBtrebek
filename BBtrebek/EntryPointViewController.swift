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
        
        let cardWidth = frameWidth.subtracting(CGFloat(offsetWidth * 2))
        let cardHeight = frameHeight.subtracting(CGFloat(offsetHeight * 2))
        return CardView(
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
