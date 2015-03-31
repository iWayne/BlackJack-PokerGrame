//
//  ViewController.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/26/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var players:[Player] = []
    var shoe:Shoe = Shoe(numberOfDecks: 3)
    var numberOfPlayer = 2
    var numberOfDeck = 3
    var playersLabel:[UILabel] = []
    var drawnCards: [UIImageView] = []
    var cardAreaX: [Int] = []
    
    var cardArea: [UIView] = []
    var playersBank:[UILabel] = []
    var playersScore:[String] = []
    var playersBet:[String] = []
    var playersStatus:[UILabel] = []
    var whoseTurn: Int=0
    var round = 0
    var col: UIColor = UIColor.darkTextColor()
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var dealerStatus: UILabel!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var AIStatus: UILabel!
    @IBOutlet weak var playerBank: UILabel!
    @IBOutlet weak var AIBank: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var aiLabel: UILabel!
    
    @IBOutlet weak var dealerCardArea: UIView!
    @IBOutlet weak var aiCardArea: UIView!
    @IBOutlet weak var playerCardArea: UIView!
    @IBOutlet weak var playerViewArea: UIView!
    
    @IBOutlet weak var betButtonsSubView: UIView!
    @IBOutlet weak var gameButtonsSubView: UIView!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    
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
    @IBAction func nextRound(sender: UIButton) {
        removeAllCard()
        updatePlayer()
        players[numberOfPlayer].newHand()
        updateDealer()
        nextRoundButton.hidden = true
        hiddenMoneyButton(false)
        whoseTurn = 0
        playerViewArea.backgroundColor = col
        round++
        status.text = "Place Bet"
    }
    @IBAction func deal(sender: UIButton) {
        if(round == 5){
            shoe = Shoe(numberOfDecks: numberOfDeck)
            round = 0
        }
        if(players[whoseTurn].hands[0].bet<=0){
            status.text = "Must place bet!"
        }else{
            if(whoseTurn<numberOfPlayer-1){
                whoseTurn++
                status.text = players[whoseTurn].name + ", place bet"
                if(whoseTurn == 1) {aiBetThink()}
            }else{
                hiddenMoneyButton(true)
                firstDeal()
                updatePlayer()
                updateDealer()
                whoseTurn = 0
                status.text = "Stand or hit?"
                gameButtonsSubView.hidden = false
            }
        }
    }
    @IBAction func hit(sender: UIButton) {
        getOneCard(whoseTurn)
        updatePlayer()
        if(players[whoseTurn].hands[0].score>21){
            whoseTurn++
            if whoseTurn == 0 {
            }else if whoseTurn == 1 {
                showGameButton(true)
                aiGameThink()
                whoseTurn++
                checkWinner()
            }else{
                checkWinner()
            }
        }
    }
    @IBAction func stand(sender: UIButton) {
        whoseTurn++
        if whoseTurn == 0 {
        }else if whoseTurn == 1{
            showGameButton(true)
            aiGameThink()
            whoseTurn++
            checkWinner()
        }else{
            checkWinner()
        }
    }
    
    func checkWinner(){
        gameButtonsSubView.hidden = true
        aiGameThink()
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
    
    func aiGameThink(){
        while players[whoseTurn].hands[0].score<16{
            getOneCard(whoseTurn)
        }
        if(whoseTurn == 2) {updateDealer()}
        if(whoseTurn == 1) {updatePlayer()}
    }
    func aiBetThink(){
        if(players[whoseTurn].bankRoll>10) {
            players[whoseTurn].hands[0].bet = 0.1 * players[whoseTurn].bankRoll
        }else{
            players[whoseTurn].hands[0].bet = players[whoseTurn].bankRoll
        }
        updatePlayer()
        deal(dealButton)
    }
    func hiddenMoneyButton(hidden: Bool){
        dealButton.hidden = hidden
        betButtonsSubView.hidden = hidden
    }
    
    func firstDeal(){
        for i in 0...numberOfPlayer{
            for j in 0...1{
                getOneCard(i)
            }
        }
    }
    
    func updateDealer(){
        var countOfCard = players[numberOfPlayer].hands[0].cards.count
        dealerStatus.text = "Score: " + String(players[numberOfPlayer].hands[0].score)
    }
    
    func updatePlayer(){
        for i in 0...numberOfPlayer-1{
            var cards:String = ""
            playersBank[i].text = "Bank: " + String(format:"%.1f",players[i].bankRoll)
            playersBet[i] = "Bet: " + String(format:"%.1f",players[i].hands[0].bet)+"  "
            playersScore[i] = "Score: " + String(players[i].hands[0].score)
            playersStatus[i].text = playersBet[i] + playersScore[i]
            for card in players[i].hands[0].cards{
            }
        }
    }
    
    func drawOneCard(imageName: String, turn: Int){
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: cardAreaX[turn], y: 0, width: 60, height: 90)
        imageView.contentMode = .ScaleAspectFit
        drawnCards.append(imageView)
        cardArea[turn].addSubview(imageView)
        cardAreaX[turn] += 20
    }
    
    func showGameButton(hidden:Bool) {
        gameButtonsSubView.hidden = hidden
        
    }
    
    func getOneCard(turn: Int){
        var card: Card = shoe.getOneCard()
        players[turn].hands[0].cards.append(card)
        drawOneCard(card.getCardString(), turn: turn)
    }
    
    func removeAllCard(){
        for cardView in drawnCards{
            cardView.removeFromSuperview()
        }
    }
    
    func initalDesk(){
        for i in 0...numberOfPlayer-1{
            playersBank[i].text = "Bank: " + String(format:"%.1f",players[i].bankRoll)
            playersBet[i] = "Bet: " + String(format:"%.1f",players[i].hands[0].bet)+"  "
            playersScore[i] = "Score: 0"
            playersStatus[i].text = playersBet[i]+playersScore[i]
        }
        playersStatus[numberOfPlayer].hidden = false
        playersStatus[numberOfPlayer].text = "Score: 0"
        nextRoundButton.hidden = true
        playerViewArea.backgroundColor = col
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shoe = Shoe(numberOfDecks: numberOfDeck)
        players = []
        players.append(Player(name: "Player"))
        players.append(Player(name: "AI"))
        players.append(Player(name: "Dealer"))
        col = col.colorWithAlphaComponent(0.1)
        cardArea = [playerCardArea, aiCardArea, dealerCardArea]
        cardAreaX = [0,0,0]
        playersBank = [playerBank, AIBank]
        playersStatus = [playerStatus, AIStatus, dealerStatus]
        playersScore = ["","",""]
        playersBet = ["","",""]
        playersLabel = [playerLabel, aiLabel]
        initalDesk()
        showGameButton(true)
        status.text = String("Player please bet")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

