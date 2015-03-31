//
//  Player.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Player {
    var name:String
    var moneyRemainder: Double
    var hands:[Hand] = []
    var bankRoll:Double{
        get{
            var remainder = moneyRemainder
            if(!hands.isEmpty){
                for hand in hands{
                    remainder -= hand.bet
                }
            }
            return remainder
        }
    }
    init(name:String){
        self.name = name
        hands.append(Hand())
        moneyRemainder = 100
    }
    func newHand(){
        if(!hands.isEmpty){
            for hand in hands{
                moneyRemainder -= hand.bet
            }
        }
        hands.removeAll()
        hands.append(Hand())
    }
}