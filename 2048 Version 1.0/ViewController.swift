//
//  ViewController.swift
//  2048 Version 1.0
//
//  Created by Viet Anh Doan on 6/27/17.
//  Copyright © 2017 Viet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    var b = Array(repeating:Array(repeating:0,count:4),count:4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomNum()
        let directions: [UISwipeGestureRecognizerDirection] = [.right,.left,.up,.down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
            
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) -> Void {
        if !end() {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.left:
                    left()
                    randomNum()
                    print("left")
                case UISwipeGestureRecognizerDirection.right:
                    right()
                    randomNum()
                    print("right")
                case UISwipeGestureRecognizerDirection.up:
                    up()
                    randomNum()
                    print("up")
                case UISwipeGestureRecognizerDirection.down:
                    down()
                    randomNum()
                    print("down")
                default:
                    break
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Game Over", message: "You Lose", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("End !")
        }
    }
    
    func randomNum() -> Void {
        if iafr() {
            var rnlabelX,rnlableY: Int
            let rdNum = arc4random_uniform(2) == 0 ? 2 : 4
            repeat {
                rnlabelX = Int(arc4random_uniform(4))
                rnlableY = Int(arc4random_uniform(4))
            } while b[rnlabelX][rnlableY] != 0
            b[rnlabelX][rnlableY] = rdNum
            transfer()
        }
        print("")
    }
    
    // is available for random
    func iafr() -> Bool {
        for i in 0...3 {
            for j in 0...3 {
                if b[i][j] == 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func up() -> Void {
        for col in 0 ..< 4 {
            var check = false
            for row in 1..<4 {
                var tx = row
                if b[row][col] == 0 {
                    continue
                }
                for rowc in (0...row - 1).reversed(){
                    if b[rowc][col] != 0 && b[rowc][col] != b[row][col] || check {
                        break
                    }
                    else {
                        tx = rowc
                    }
                }
                if tx == row {
                    continue
                }
                if b[row][col] == b[tx][col]
                {
                    check = true
                    getScore(value: b[tx][col])
                    b[tx][col] *= 2
                }
                else {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    func left() -> Void {
        for row in 0 ..< 4 {
            var check = false
            for col in 1..<4 {
                var tx = col
                if b[row][col] == 0 {
                    continue
                }
                for colc in (0...col - 1).reversed(){
                    if b[row][colc] != 0 && b[row][colc] != b[row][col] || check {
                        break
                    }
                    else {
                        tx = colc
                    }
                }
                if tx == col {
                    continue
                }
                if b[row][col] == b[row][tx]
                {
                    check = true
                    getScore(value: b[row][tx])
                    b[row][tx] *= 2
                }
                else {
                    b[row][tx] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    func right() -> Void {
        for row in 0 ..< 4 {
            var check = false
            for col in (0..<3).reversed() {
                var tx = col
                if b[row][col] == 0 {
                    continue
                }
                for colc in col+1..<4{
                    if b[row][colc] != 0 && b[row][colc] != b[row][col] || check {
                        break
                    }
                    else {
                        tx = colc
                    }
                }
                if tx == col {
                    continue
                }
                if b[row][col] == b[row][tx]
                {
                    check = true
                    getScore(value: b[row][tx])
                    b[row][tx] *= 2
                }
                else {
                    b[row][tx] = b[row][col]
                }
                b[row][col] = 0
            }
        }
        
    }
    
    func down() -> Void {
        for col in 0 ..< 4 {
            var check = false
            for row in (0..<3).reversed() {
                var tx = row
                if b[row][col] == 0 {
                    continue
                }
                for rowc in row + 1 ..< 4 {
                    if b[rowc][col] != 0 && b[rowc][col] != b[row][col] || check {
                        break
                    }
                    else {
                        tx = rowc
                    }
                }
                if tx == row {
                    continue
                }
                if b[row][col] == b[tx][col]
                {
                    check = true
                    getScore(value: b[tx][col])
                    b[tx][col] *= 2
                }
                else {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    
    func convertNumLabel(numlabel: Int, value: String) -> Void {
        let label = view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    
    func changeBackColor(numlabel: Int, color: UIColor) -> Void {
        let label = view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    
    func transfer(){
        for i in 0..<4 {
            for j in 0..<4 {
                let numlabel = 100 + (i * 4) + j
                convertNumLabel(numlabel: numlabel, value: String(b[i][j]))
                switch b[i][j] {
                case 0:
                    changeBackColor(numlabel: numlabel, color: .lightGray)
                case 2,4:
                    changeBackColor(numlabel: numlabel, color: .green)
                case 8:
                    changeBackColor(numlabel: numlabel, color: .magenta)
                case 16:
                    changeBackColor(numlabel: numlabel, color: .purple)
                case 64:
                    changeBackColor(numlabel: numlabel, color: .yellow)
                default:
                    break
                }
            }
        }
    }
    
    func getScore(value: Int){
        score.text = String(Int(score.text!)! + value)
    }
    
    func end() -> Bool {
        for i in 0..<3 {
            for j in 0..<3 {
                if b[i][j] == 0 || b[i][j] == b[i][j+1] || b[i][j] == b[i+1][j] || b[i][j+1] == 0 || b[i+1][j] == 0{
                    return false
                }
            }
        }
        return true
    }
    
}
