//
//  ViewController.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var deckSlider: UISlider!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var deckSliderLabel: UILabel!
    @IBOutlet weak var playerSliderLabel: UILabel!
    
    @IBAction func deckSliderChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        deckSliderLabel.text = String(currentValue)
        let myData = Singleton.sharedInstance
        myData.numberOfDecks = Int(deckSlider.value)
    }
    @IBAction func playerSliderChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        playerSliderLabel.text = String(currentValue)
        let myData = Singleton.sharedInstance
        myData.numberOfplayer = Int(playerSlider.value)
    }
    @IBAction func startGame(sender: UIButton) {
        /*
        let myData = Singleton.sharedInstance
        myData.numberOfDecks = Int(deckSlider.value)
        myData.numberOfplayer = Int(playerSlider.value)
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deckSliderLabel.text = "3"
        playerSliderLabel.text = "2"
        let myData = Singleton.sharedInstance
        myData.numberOfDecks = 3
        myData.numberOfplayer = 2
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

