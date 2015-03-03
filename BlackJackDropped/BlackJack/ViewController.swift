//
//  ViewController.swift
//  BlackJack
//
//  Created by Shan Shawn on 2/13/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var card=[Int](count: 52, repeatedValue: 0)
    var round=0
    let player=Gamer()
    let dealer=Gamer()
    var dealerBJ=false
    
    @IBOutlet weak var dealOpenCard: UILabel!
    @IBOutlet weak var dealHiddenCards: UILabel!
    @IBOutlet weak var playerCards: UILabel!
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var betNum: UILabel!
    @IBOutlet weak var bankRoll: UILabel!
    @IBOutlet weak var dScoreNum: UILabel!
    @IBOutlet weak var pScoreNum: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var surrenderButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var twentyButton: UIButton!
    @IBOutlet weak var fiftyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var insuranceButton: UIButton!
    
    @IBAction func restartButton(sender: UIButton) {
        restart()
    }
    
    @IBAction func insurance(sender: UIButton) {
        if(dealer.blackjack){
            player.clearBet()
            steps.text="Dealer's BJ, but Insurance"
        }else{
            player.bankRollInt -= player.betNum/2
            updateBankAndBet()
            steps.text="No BJ, Continue"
        }
        dealOpenCard.text = dealOpenCard.text! + dealHiddenCards.text!
        dealHiddenCards.text=""
        insuranceButton.hidden=true
    }
    
    @IBAction func addDollar(sender: UIButton) {
        var amount:Double=0
        var st:String! = sender.titleLabel?.text
        var st2:String = st
        switch st2{
            case "$1":
                amount=1.0
            case "$5":
                amount=5.0
            case "$10":
                amount=10.0
            case "$20":
                amount=20.0
            case "$50":
                amount=50.0
            default:
                amount=0
        }
        if(!player.putMoney(amount)){
            steps.text="You have not enough money!"
        }
        updateBankAndBet()
    }
    
    @IBAction func clearDollar(sender: UIButton) {
        player.clearBet()
        updateBankAndBet()
    }
    
    @IBAction func deal(sender: UIButton) {
        showDealerInfo(false)
        insuranceButton.hidden=true
        steps.text="Choose"
        if(player.betNum<=0){
            steps.text="Place bet first!"
            return
        }
        //if the 6th round, shuffle
        if (round==5) {
            card=[Int](count: 52, repeatedValue: 0)
            round=0
        }
        //At the beginning, get 2 cards for each people
        round++
        get4CardsAtBegin()
        betView(false)
    }
    
    @IBAction func surrender(sender: UIButton) {
        player.surrender()
        updateBankAndBet()
        steps.text="Surrender"
        nextRound()
    }
    
    @IBAction func double(sender: UIButton) {
        if(!player.putMoney(player.betNum)){
            steps.text="You have not enough money!"
            return
        }else{
            updateBankAndBet()
            steps.text="Double!"
            var newCard=getOneCard()
            if(player.addCard(newCard)){
                playerCards.text = playerCards.text! + player.getCardPattern(newCard)
                pScoreNum.text=String(player.score)
            }else{
                pScoreNum.text="bust!"
            }
            
        }
        dealerThink()
        checkWinner()
    }
    
    @IBAction func hit(sender: UIButton) {
        steps.text="Hit"
        doubleButton.hidden=true
        var newCard=getOneCard()
        if(player.addCard(newCard)){
            playerCards.text = playerCards.text! + player.getCardPattern(newCard)
            pScoreNum.text=String(player.score)
        }else{
            pScoreNum.text="bust!"
            playerCards.text = playerCards.text! + player.getCardPattern(newCard)
            checkWinner()
        }
    }
    
    @IBAction func stand(sender: UIButton) {
        dealerThink()
        checkWinner()
    }
    
    func updateBankAndBet(){
        bankRoll.text=String(format:"%.1f",player.bankRollInt)
        betNum.text=String(format:"%.1f",player.betNum)
    }
    
    func get4CardsAtBegin(){
        //Deal four cards
        var pcard1=getOneCard()
        var pcard2=getOneCard()
        var dcard1=getOneCard()
        var dcard2=getOneCard()
        
        //Initialize Score
        player.addCard(pcard1)
        player.addCard(pcard2)
        dealer.addCard(dcard1)
        dealer.addCard(dcard2)
        
        //Print Score and Cards on the Screen
        playerCards.text=player.getCardPattern(pcard1)+player.getCardPattern(pcard2)
        dealOpenCard.text=dealer.getCardPattern(dcard1)
        dealHiddenCards.text=dealer.getCardPattern(dcard2)
        dScoreNum.text=String(dealer.score)
        pScoreNum.text=String(player.score)
        
        //Check if BJ
        player.checkBJ()
        dealer.checkBJ()
        
        //player BJ
        if(player.blackjack){
            playerBJCheck()
            return
        }
        //Check if Insurance is needed
        if(dcard1==0){
            insuranceButton.hidden=false
        }
    }
    
    func getOneCard()->Int{
        var CardNum=Int(arc4random()%52)
        while(card[CardNum]==1){
            CardNum=Int(arc4random()%52)
        }
        card[CardNum]=1
        return CardNum
    }
    
    func dealerThink(){
        while(dealer.score<16){
            var newCard=getOneCard()
            dealer.addCard(newCard)
            dealHiddenCards.text = dealHiddenCards.text! + dealer.getCardPattern(newCard)
            dScoreNum.text = String(dealer.score)
        }
    }
    
    func dealerBJCheck(){
        if(dealer.blackjack){
            checkWinner()
        }
    }
    
    func playerBJCheck(){
        if(dealer.blackjack){
            player.clearBet()
            steps.text="Push"
        }else{
            player.win(2)
            steps.text="BJ!"
        }
        betView(true)
    }
    
    func checkWinner(){
        if(player.score>21){
            player.lose()
            steps.text="Lose"
        }else if(dealer.score>21){
            player.win(1)
            steps.text="Win!"
        }else if(player.score>dealer.score){
            player.win(1)
            steps.text="Win!"
        }else if(player.score==dealer.score){
            player.clearBet()
            steps.text="Push"
        }else{
            player.lose()
            steps.text="Lose"
        }
        updateBankAndBet()
        nextRound()
    }
    
    func showDealerInfo(status:Bool){
        dealHiddenCards.hidden = !status
        dScoreNum.hidden = !status
    }
    
    func betView(status:Bool){
        //After Deal
        surrenderButton.hidden = status
        doubleButton.hidden = status
        hitButton.hidden = status
        standButton.hidden = status
        //Button
        oneButton.hidden = !status
        fiveButton.hidden = !status
        twentyButton.hidden = !status
        fiftyButton.hidden = !status
        clearButton.hidden = !status
        dealButton.hidden = !status
    }
    
    func nextRound(){
        player.readyForNextRound()
        dealer.readyForNextRound()
        showDealerInfo(true)
        betView(true)
    }
    
    func restart(){
        //player&dealer
        player.whetherPlayer=true
        player.inital()
        dealer.inital()
        //dealerView
        dealOpenCard.text=""
        dealHiddenCards.text=""
        dealHiddenCards.hidden=true
        dScoreNum.text="0"
        //playerView
        playerCards.text=""
        pScoreNum.text="0"
        //Steps
        steps.text="Place Bet"
        //Money
        betNum.text="0.0"
        bankRoll.text="100.0"
        //ButtonHidden
        betView(true)
        insuranceButton.hidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

