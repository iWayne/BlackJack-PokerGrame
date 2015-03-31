//
//  Card.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Card{
    var cardIndex:Int
    var rank:Int{
        get{
            var value = 0
            value = cardIndex/4 + 1
            if value > 10 {value=10}
            return value
        }
    }
    var suit:String{
        get{
            switch cardIndex/13{
            case 0:
                return "spades"
            case 1:
                return "hearts"
            case 2:
                return "diamonds"
            case 3:
                return "clubs"
            default:
                return "out"
            }
        }
    }
    init(cardIndex:Int){
        self.cardIndex = cardIndex
    }
    func getCardString ()->String{
        var retrunString = ""
        switch rank{
        case 1:
            retrunString+="ace"
        case 2...10:
            retrunString+=String(rank)
        case 11:
            retrunString+="jack"
        case 12:
            retrunString+="queen"
        case 13:
            retrunString+="king"
        default:
            retrunString+="Out"
        }
        //returnString = returnString + "_of_" + suit + ".png"
        return retrunString + "_of_" + suit + ".png"
    }
}