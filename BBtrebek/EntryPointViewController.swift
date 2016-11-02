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
    }
}
