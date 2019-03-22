//
//  ViewController.swift
//  guestNumber2
//
//  Created by Shun-Ching, Chou on 2018/10/25.
//  Copyright © 2018 Shun-Ching, Chou. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet var numberTextFields: [UITextField]!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var answerArray = [Int](repeating: 0, count: 4)
    var guestIndex = -1
    var guestTimes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initGame()
    }
    
    func initGame() {
        // 清空作答區
        historyTextView.text = ""
        guestTimes = 0
        clear()
        
        //隨機決定4位數的答案，數字不能重複
        var rangeNumber = [Int](0...9)
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: rangeNumber.count - 1)
        for i in 0...3 {
            let index = shuffledDistribution.nextInt()
            answerArray[i] = rangeNumber[index]
        }
        quitButton.isEnabled = true
        cancelButton.isEnabled = true
        sendButton.isEnabled = true
    }
    
    func clear() {
        for textfield in numberTextFields {
            textfield.text = ""
        }
        guestIndex = -1
        for button in numberButtons{
            button.isEnabled = true
        }
    }
    func gameOver(win: Bool){
        if win {
            historyTextView.text += "恭喜答對！\n"
        } else {
            historyTextView.text += "殘念..正解：\(answerArray[0])\(answerArray[1])\(answerArray[2])\(answerArray[3])\n"
        }
        quitButton.isEnabled = false
        cancelButton.isEnabled = false
        sendButton.isEnabled = false
        for button in numberButtons{
            button.isEnabled = false
        }
    }

    @IBAction func numberButton(_ sender: UIButton) {
        // 玩家已經選擇4個數字，之後點選的數字就忽略
        if guestIndex == 4 {
            return
        }
        // 將index指到下一個位置
        guestIndex += 1
        // 取得button值放進text field中
        numberTextFields[guestIndex].text = "\(sender.tag)"
        // Disable button避免選到重複的數字
        numberButtons[sender.tag].isEnabled = false
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        // 當index在有值的range時才動作
        if guestIndex > -1 || guestIndex < 4 {
            let num = Int(numberTextFields[guestIndex].text!)
            numberButtons[num!].isEnabled = true
            numberTextFields[guestIndex].text = ""
            guestIndex -= 1
        }
    }
    @IBAction func sendButton(_ sender: UIButton) {
        guestTimes += 1
        if guestIndex != 3 {
            return
        }
        var countA = 0
        var countB = 0
        var guestNumber = [Int](repeating: 0, count: 4)
        for i in 0...3 {
            let num = Int(numberTextFields[i].text!)!
            guestNumber[i] = num
            if num == answerArray[i] {
                countA += 1
            } else if answerArray.contains(num){
                countB += 1
            }
        }
        let result = "\(guestTimes): \(guestNumber[0])\(guestNumber[1])\(guestNumber[2])\(guestNumber[3])  \(countA)A\(countB)B\n"
        historyTextView.text += result
        historyTextView.scrollRangeToVisible(NSMakeRange(historyTextView.text.count - 1, 0))
        historyTextView.layoutManager.allowsNonContiguousLayout = false;

        if countA == 4 {
            gameOver(win: true)
            return
        }
        clear()
    }
    
    @IBAction func quitButton(_ sender: UIButton) {
        gameOver(win: false)
    }
    @IBAction func restartButton(_ sender: UIButton) {
        initGame()
    }
}

