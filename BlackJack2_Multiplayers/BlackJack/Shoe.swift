//
//  Shoe.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Shoe {
    var numberOfDecks: Int
    var cards: [Int]
    init(numberOfDecks:Int=3){
        self.numberOfDecks = numberOfDecks
        cards = [Int](count:52, repeatedValue:0)
    }
    func getOneCard()->Card{
        var cardIndex = Int(arc4random()%52)
        while ( cards[cardIndex] >= numberOfDecks){
            cardIndex = Int(arc4random()%52)
        }
        cards[cardIndex]++
        var newCard = Card(cardIndex: cardIndex)
        return newCard
    }
    func shuffle(){
        cards = [Int](count:52, repeatedValue:0)
    }
}