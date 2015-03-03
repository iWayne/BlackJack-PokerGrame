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
                return "♠"
            case 1:
                return "♥"
            case 2:
                return "♦"
            case 3:
                return "♣"
            default:
                return "out"
            }
        }
    }
    init(cardIndex:Int){
        self.cardIndex = cardIndex
    }
    func getCardString ()->String{
        var retrunString = suit
        switch rank{
        case 1:
            retrunString+="A, "
        case 2...10:
            retrunString+=String(rank)+", "
        case 11:
            retrunString+="J, "
        case 12:
            retrunString+="Q, "
        case 13:
            retrunString+="K, "
        default:
            retrunString+="Out, "
        }
        return retrunString
    }
}