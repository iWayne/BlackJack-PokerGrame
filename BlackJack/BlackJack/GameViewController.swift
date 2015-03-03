//
//  GameViewController.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var players:[Player] = []
    var shoe:Shoe = Shoe(numberOfDecks: 3)
    var numberOfPlayer = 2
    var numberOfDeck = 3
    var playersLabel:[UILabel] = []
    var playersCard:[UILabel] = []
    var playersBank:[UILabel] = []
    var playersScore:[UILabel] = []
    var playersBet:[UILabel] = []
    var whoseTurn: Int=0
    var round = 0
    
    @IBOutlet weak var dealerShowCard: UILabel!
    @IBOutlet weak var dealerHiddenCard: UILabel!
    @IBOutlet weak var dealerScore: UILabel!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1Card: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player1Bet: UILabel!
    @IBOutlet weak var player1Bank: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2Card: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var player2Bet: UILabel!
    @IBOutlet weak var player2Bank: UILabel!
    @IBOutlet weak var player3Label: UILabel!
    @IBOutlet weak var player3Card: UILabel!
    @IBOutlet weak var player3Score: UILabel!
    @IBOutlet weak var player3Bet: UILabel!
    @IBOutlet weak var player3Bank: UILabel!
    @IBOutlet weak var player4Label: UILabel!
    @IBOutlet weak var player4Card: UILabel!
    @IBOutlet weak var player4Score: UILabel!
    @IBOutlet weak var player4Bet: UILabel!
    @IBOutlet weak var player4Bank: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var fiftyButton: UIButton!
    @IBOutlet weak var twentyButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    @IBAction func nextRound(sender: UIButton) {
        updatePlayer()
        players[numberOfPlayer].newHand()
        updateDealer()
        nextRoundButton.hidden = true
        dealerHiddenCard.hidden = true
        dealerScore.hidden = true
        hiddenMoneyButton(false)
        whoseTurn = 0
        playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
        round++
    }
    
    @IBAction func deal(sender: UIButton) {
        if(round == 5){
            shoe = Shoe(numberOfDecks: numberOfDeck)
            round = 0
        }
        if(players[whoseTurn].hands[0].bet<=0){
            status.text = "Must place bet!"
        }else{
        playersLabel[whoseTurn].backgroundColor = UIColor.whiteColor()
        if(whoseTurn<numberOfPlayer-1){
            whoseTurn++
            playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
            status.text = players[whoseTurn].name + ", place bet"
        }else{
            hiddenMoneyButton(true)
            firstDeal()
            updatePlayer()
            updateDealer()
            whoseTurn = 0
            playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
            status.text = "Stand or hit?"
            standButton.hidden = false
            hitButton.hidden = false
            }
        }
    }
    
    @IBAction func setBet(sender: UIButton) {
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
        case "Clear":
            amount=0
        default:
            amount=0
        }
        if(players[whoseTurn].bankRoll<amount){
            status.text = "No enough money!"
        }else if amount==0{
            players[whoseTurn].hands[0].bet=0;
        }
        else{
            players[whoseTurn].hands[0].bet+=amount;
        }
        updatePlayer()
    }
    
    @IBAction func hit(sender: UIButton) {
        players[whoseTurn].hands[0].cards.append(shoe.getOneCard())
        updatePlayer()
        if(players[whoseTurn].hands[0].score>21){
            playersLabel[whoseTurn].backgroundColor = UIColor.whiteColor()
            whoseTurn++
            if whoseTurn < numberOfPlayer {
                playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
            }else{
                checkWinner()
            }
        }
        
    }
    @IBAction func stand(sender: UIButton) {
        playersLabel[whoseTurn].backgroundColor = UIColor.whiteColor()
        whoseTurn++
        if whoseTurn < numberOfPlayer {
            playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
        }else{
            checkWinner()
        }
    }
    func checkWinner(){
        hitButton.hidden = true
        standButton.hidden = true
        dealerHiddenCard.hidden = false
        dealerScore.hidden = false
        dealerThink()
        var listWinner: String = ""
        if players[numberOfPlayer].hands[0].score > 21 {
            for player in players[0...numberOfPlayer-1] {
                listWinner += player.name + " "
                if player.hands[0].score > 21 {
                    player.hands[0].win(time: 0)
                    listWinner += "Push, "
                }
                else { player.hands[0].win()
                    listWinner += "Win, "
                }
                player.newHand()
            }
        }else{
            var dealerScore = players[numberOfPlayer].hands[0].score
            for player in players[0...numberOfPlayer-1] {
                listWinner += player.name + " "
                if (player.hands[0].score <= 21 && player.hands[0].score > dealerScore) {
                    listWinner += "Win, "
                    player.hands[0].win()
                }else if (player.hands[0].score == dealerScore) {
                    player.hands[0].win(time: 0)
                    listWinner += "Push, "
                }else{
                    listWinner += "Lose, "
                    player.hands[0].lose()
                }
                player.newHand()
            }
        }
        status.text = listWinner
        nextRoundButton.hidden = false
    }
    
    func dealerThink(){
        while players[numberOfPlayer].hands[0].score<16{
            players[numberOfPlayer].hands[0].cards.append(shoe.getOneCard())
        }
        updateDealer()
    }
    
    func hiddenMoneyButton(hidden: Bool){
        dealButton.hidden = hidden
        oneButton.hidden = hidden
        fiveButton.hidden = hidden
        twentyButton.hidden = hidden
        fiftyButton.hidden = hidden
        clearButton.hidden = hidden
    }
    
    func firstDeal(){
        for i in 0...numberOfPlayer-1{
            players[i].hands[0].cards.append(shoe.getOneCard())
            players[i].hands[0].cards.append(shoe.getOneCard())
        }
        players[numberOfPlayer].hands[0].cards.append(shoe.getOneCard())
        players[numberOfPlayer].hands[0].cards.append(shoe.getOneCard())
    }
    
    func updateDealer(){
        if(players[numberOfPlayer].hands[0].cards.count>0){
        dealerShowCard.text = players[numberOfPlayer].hands[0].cards[0].getCardString()+players[numberOfPlayer].hands[0].cards[1].getCardString()
        }else {
            dealerShowCard.text = ""
        }
        var countOfCard = players[numberOfPlayer].hands[0].cards.count
        var hiddenCards:String = ""
        for var i=2; i<countOfCard; i++ {
            hiddenCards += players[numberOfPlayer].hands[0].cards[i].getCardString()
        }
        dealerHiddenCard.text = hiddenCards
        
        dealerScore.text = "Score: " + String(players[numberOfPlayer].hands[0].score)
    }
    
    func updatePlayer(){
        for i in 0...numberOfPlayer-1{
            var cards:String = ""
            playersBank[i].text = "Bank: " + String(format:"%.1f",players[i].bankRoll)
            playersBet[i].text = "Bet: " + String(format:"%.1f",players[i].hands[0].bet)
            playersScore[i].text = "Score: " + String(players[i].hands[0].score)
            for card in players[i].hands[0].cards{
                cards += card.getCardString()
            }
            playersCard[i].text = cards
        }
    }
    
    func hiddenPlayer(){
        for i in 0...3{
            if(i<numberOfPlayer){
                playersLabel[i].hidden = false
                playersBank[i].hidden = false
                playersBet[i].hidden = false
                playersCard[i].hidden = false
                playersScore[i].hidden = false
            }else{
                playersLabel[i].hidden = true
                playersBank[i].hidden = true
                playersBet[i].hidden = true
                playersCard[i].hidden = true
                playersScore[i].hidden = true
            }
        }
    }
    
    func initalDesk(){
        for i in 0...numberOfPlayer-1{
            playersBank[i].text = "Bank: " + String(format:"%.1f",players[i].bankRoll)
            playersBet[i].text = "Bet: " + String(format:"%.1f",players[i].hands[0].bet)
            playersCard[i].text = ""
            playersScore[i].text = "Score: 0"
        }
        dealerHiddenCard.hidden = true
        dealerScore.hidden = true
        dealerShowCard.text = ""
        dealerScore.text = "Score: 0"
        playersLabel[whoseTurn].backgroundColor = UIColor.brownColor()
        nextRoundButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myData = Singleton.sharedInstance
        shoe = Shoe(numberOfDecks: myData.numberOfDecks)
        players = []
        for i in 0...myData.numberOfplayer{
            players.append(Player(name: "Player"+String(i+1)))
        }
        numberOfPlayer = myData.numberOfplayer
        numberOfDeck = myData.numberOfDecks
        
        playersLabel = [player1Label, player2Label, player3Label, player4Label]
        playersBank = [player1Bank, player2Bank, player3Bank, player4Bank]
        playersBet = [player1Bet, player2Bet, player3Bet, player4Bet]
        playersCard = [player1Card, player2Card, player3Card, player4Card]
        playersScore = [player1Score, player2Score, player3Score, player4Score]
        hiddenPlayer()
        initalDesk()
        status.text = String("Player 1, Plcase bet")
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
