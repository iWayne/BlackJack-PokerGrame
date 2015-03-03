//
//  bjClass.swift
//  BlackJack
//
//  Created by Shan Shawn on 2/16/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Gamer{
    var bankRollInt:Double=0
    var betNum:Double=0
    var score:Int=0
    var aceFor11:Int=0
    var whetherPlayer=true
    var blackjack=false
    
    func checkBJ(){
        if(score==21){
            blackjack=true
        }
    }
    
    func addCard(cardNum:Int)->Bool{
        var cardValue = cardNum/4+1
        if(cardValue>10) {cardValue=10}
        
        if(cardValue==1){
            if(score+11<=21) {
                aceFor11++
                score=score+11
            }else{
                score++
            }
        }else{
            score+=cardValue
            if(score>21 && aceFor11>0){
                score -= 10
                aceFor11--
            }
        }
        if(score<=21) {return true}
        else {return false}
    }
    
    func inital(){
        if(whetherPlayer==true){
            bankRollInt=100.0
        }
        betNum=0
        score=0
        aceFor11=0
        blackjack=false
    }
    
    func putMoney(amount:Double)->Bool{
        if(amount>bankRollInt){
            return false
        }
        bankRollInt -= amount
        betNum += amount
        return true
    }
    
    func readyForNextRound(){
        score=0
        aceFor11=0
        blackjack=false
    }
    
    func clearBet(){
        bankRollInt += betNum
        betNum=0
    }
    
    func surrender(){
        bankRollInt += betNum/2
        betNum=0
    }
    
    func lose(){
        betNum=0
    }
    
    func win(time:Double){
        bankRollInt += betNum*(time+1)
        betNum=0
    }
    
    func getCardPattern(CardNum:Int)->String{
        var pattern="";
        switch CardNum/13{
        case 0:
            pattern="♠"
        case 1:
            pattern="♥"
        case 2:
            pattern="♦"
        case 3:
            pattern="♣"
        default:
            pattern="out of 4"
        }
        switch CardNum/4{
        case 0:
            pattern+="A, "
        case 1...9:
            pattern+=String(CardNum/4+1)+", "
        case 10:
            pattern+="J, "
        case 11:
            pattern+="Q, "
        case 12:
            pattern+="K, "
        default:
            pattern+="Out, "
        }
        return pattern
    }
    
}