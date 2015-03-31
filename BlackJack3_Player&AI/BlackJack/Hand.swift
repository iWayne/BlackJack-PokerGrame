//
//  Hand.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Hand{
    var cards: [Card]
    var bet: Double
    var score: Int{
        get{
            var sum:Int = 0
            var aces: Int = 0
            for card in cards {
                if card.rank==1 {
                    aces++
                }
                sum += card.rank
            }
            for var i=0;i<aces;i++ {
                if(sum+10<=21) {sum+=10}
                else {break}
            }
            return sum
        }
    }
    init(){
        cards = []
        bet = 0.0
    }
    func addOneCard(newCard:Card) {
        cards.append(newCard)
    }
    func setBet(betNum:Double){
        bet = betNum
    }
    func lose(){
    }
    func win(time: Double=1.0){
        bet -= bet*(time+1)
    }
}