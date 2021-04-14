//
//  GameViewController.swift
//  Firebase_PaperScissorsStone
//
//  Created by 曲奕帆 on 2021/4/13.
//

import UIKit
//import Foundation
import Firebase

class GameViewController: UIViewController {
    
    var myDocRef: DocumentReference!
    var opponentDocRef: DocumentReference!
    var quoteListener: ListenerRegistration!
    
    var opponent: String = ""
    var player: String = ""{
        didSet{ opponent = (player == "Alice") ? "Bob" : "Alice"}
    }
    
    var gameIsOn = false
    
    let gestureEmoji = ["✌️", "👊", "✋"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myDocRef = Firestore.firestore().document("games/\(player)")
        opponentDocRef = Firestore.firestore().document("games/\(opponent)")
        sendConnectMessage()
        
        outgoMessageStatusUpdate()
        
        myGestureLabel.text = nil
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "離開遊戲", style: .plain, target: self,action: #selector(backViewBtnFnc))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quoteListener = opponentDocRef.addSnapshotListener{ (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let data = docSnapshot.data()
            let incomeMessage = data?["message"] as? String ?? ""
            self.opponentBuffer = incomeMessage
            
            print("Message received: \(self.opponentBuffer)")
            
            self.incomeMessageStatusUpdate()
        }
    }
    
    
    @IBOutlet weak var opponentGestureLabel: UILabel!
    @IBOutlet weak var myGestureLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var opponentBuffer: String = ""
    var myBuffer: String = ""
    
    
    @IBOutlet weak var paperButton: UIButton!
    @IBAction func paperButton(_ sender: UIButton) {
        myBuffer = "✋"
        let message = ["message": myBuffer]
        sendToFirebase(message)
        myGestureLabel.text = myBuffer
        hideGesturesButtons()
        outgoMessageStatusUpdate()
    }
    
    
    @IBOutlet weak var scissorsButton: UIButton!
    @IBAction func scissorsButton(_ sender: UIButton) {
        myBuffer = "✌️"
        let message = ["message": myBuffer]
        sendToFirebase(message)
        myGestureLabel.text = myBuffer
        hideGesturesButtons()
        outgoMessageStatusUpdate()
    }
    
    
    @IBOutlet weak var stoneButton: UIButton!
    @IBAction func stoneButton(_ sender: UIButton) {
        myBuffer = "👊"
        let message = ["message": myBuffer]
        sendToFirebase(message)
        myGestureLabel.text = myBuffer
        hideGesturesButtons()
        outgoMessageStatusUpdate()
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func newGameButton(_ sender: UIButton) {
        print("newGameButton action!")
        myBuffer = "new"
        let message = ["message": myBuffer]
        sendToFirebase(message)

        setNewGame()
        showGesturesButtons()
        outgoMessageStatusUpdate()
    }
    
//    func statusUpdate(){
//        print("==============statusUpdate()===================")
//        print("myGestureLabel.text: \(myGestureLabel.text)")
//        print("opponentBuffer: \(opponentBuffer)")
//
////        if  opponentBuffer == "new"{
////            statusLabel.text = "對手邀請新遊戲，請出拳"
////            setNewGame()
////            enableGesturesButtons()
////        }
//
//        if  myGestureLabel.text != nil && opponentBuffer == "new"{
//            statusLabel.text = "等待對手出拳"
//            disenableGesturesButtons()
//        }
//
//        if  opponentBuffer == "connected"{
//
//            if oppoHadConnected == false{
//                statusLabel.text = "對手已上線，請出拳"
//                oppoHadConnected = true
//            }else{
//                statusLabel.text = "對手邀請新遊戲，請出拳"
//                setNewGame()
//            }
//            enableGesturesButtons()
//        }
//
//        if  gestureEmoji.contains(opponentBuffer ?? ""){
//            statusLabel.text = "對手已出拳，請出拳"
//            enableGesturesButtons()
//        }
//
//        if myGestureLabel.text != nil && opponentBuffer == "connected"{
//            statusLabel.text = "等待對手出拳"
//            disenableGesturesButtons()
//        }
//
//        if myGestureLabel.text != nil && gestureEmoji.contains(opponentBuffer ?? ""){
//            opponentGestureLabel.text = opponentBuffer
//            winningStatus()
//            disenableGesturesButtons()
//        }
//
//        if opponentBuffer == "disconnected"{
//            statusLabel.text = "對手離線中，等待\(opponent)上線"
//            oppoHadConnected = false
//            setNewGame()
//            disenableGesturesButtons()
//        }
//
//    }
    
    func incomeMessageStatusUpdate(){
        print("incomeMessageStatusUpdate()")
        if opponentBuffer == "connected"{
            print("opponentBuffer == connected")
            gameIsOn = true
            statusLabel.text = "對手已上線，請出拳"
            sendConnectMessage()
            showGesturesButtons()
        }
        
        if opponentBuffer == "disconnected"{
            print("opponentBuffer == disconnected")
            gameIsOn = false
            statusLabel.text = "等待對手上線..."
            setNewGame()
        }
        
        if gameIsOn{
            print("gameIsOn")
            if gestureEmoji.contains(opponentBuffer){
                print(" opponentBuffer conatains")
                if myGestureLabel.text == nil{
                    print("對手已出拳")
                    statusLabel.text = "對手已出拳"
                }else{
                    print("雙方皆已出拳")
                    print("opponent: \(opponentBuffer)")
                    opponentGestureLabel.text = opponentBuffer
                    winningStatus()
                    
                }
            }
            if opponentBuffer == "new"{
                print("opponentBuffer == new")
                statusLabel.text = "對手邀請新遊戲，請出拳"
                setNewGame()
                showGesturesButtons()
            }
        }
    }
    
    func outgoMessageStatusUpdate(){
        print("outgoMessageStatusUpdate()")
        if myBuffer == "connected"{
            print("my buffer == connected")
            statusLabel.text = "等待對手上線..."
        }
        
        if myBuffer == "new"{
            print("myBuffer == new")
            statusLabel.text = "開始新遊戲，請出拳"
        }
        
        if gestureEmoji.contains(myBuffer){
            print("gestureEmoji.contains(myBuffer)")
            if !gestureEmoji.contains(opponentBuffer){
                print("等待對手出拳")
                statusLabel.text = "等待對手出拳"
            }else{
                print("test 雙方皆已出拳")
                opponentGestureLabel.text = opponentBuffer
                winningStatus()
            }
        }
        
    }
    
    
    
    func winningStatus(){
        print("winningStatus()")
        if myGestureLabel.text == opponentBuffer{
            print("winningStatus 平手")
            statusLabel.text = "平手！"
        }else{
            if myGestureLabel.text == "✋"{
                print("myGestureLabel.text == ✋")
                if opponentBuffer == "✌️" {
                    print("opponentBuffer == ✌️")
                    statusLabel.text = "你輸了！"
                }
                if opponentBuffer == "👊" {
                    print("opponentBuffer == 👊")
                    statusLabel.text = "你贏了！"
                    
                }
            }
            if myGestureLabel.text == "✌️"{
                print("myGestureLabel.text == ✌️")
                if opponentBuffer == "👊" { statusLabel.text = "你輸了！"}
                if opponentBuffer == "✋" { statusLabel.text = "你贏了！"}
            }
            if myGestureLabel.text == "👊"{
                print("myGestureLabel.text == 👊")
                if opponentBuffer == "✋" { statusLabel.text = "你輸了！"}
                if opponentBuffer == "✌️" { statusLabel.text = "你贏了！"}
//                if opponentGestureLabel.text == "✌️" { statusLabel.text = "你贏了！"}
            }
        }
        print("winningStatus(): newGameButton.isHidden = false")
        newGameButton.isHidden = false
    }
    
    func setNewGame(){
        print("setNewGame()")
        myGestureLabel.text = nil
        opponentGestureLabel.text = nil
        opponentBuffer = "connected"
        
        newGameButton.isHidden = true
        
    }
    
    func hideGesturesButtons(){
        print("hideGesturesButtons()")
        paperButton.isHidden = true
        stoneButton.isHidden = true
        scissorsButton.isHidden = true
    }
    
    func showGesturesButtons(){
        print("showGesturesButtons()")
        paperButton.isHidden = false
        stoneButton.isHidden = false
        scissorsButton.isHidden = false
    }
    
    func sendToFirebase(_ data: [String: Any]){
        myDocRef.setData(data){ error in
            if let error = error{
                print("Oh no! Got an error: \(error.localizedDescription)")
            }else{
                print("Data: \(data) has been saved!")
            }
        }
    }
    
    func sendConnectMessage(){
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            let message = ["message": "connected"]
            self.sendToFirebase(message)
        }
    }
    
    @objc func backViewBtnFnc(){
        self.navigationController?.popViewController(animated: true)
        let message = ["message": "disconnected"]
        self.sendToFirebase(message)
        self.setNewGame()
    }
    
}
