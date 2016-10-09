//
//  PlayerButton.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class PlayerButton: UIButton {
    open var player: Player = Player(name: "NULL")

    static open func initWith(player: Player, frame: CGRect) -> PlayerButton {
        let playerButton = PlayerButton(frame: frame)
        playerButton.player = player
        playerButton.setPlayerTitle()
        return playerButton
    }
 
    open func setPlayerTitle() -> Void {
        self.setTitle("\(self.player.name) - \(self.player.score())", for: UIControlState())
        self.sizeToFit()
    }
    
    public override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
