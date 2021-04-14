//
//  ViewController.swift
//  Firebase_PaperScissorsStone
//
//  Created by 曲奕帆 on 2021/4/13.
//

import UIKit
//import Firebase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //docRef = Firestore.firestore().document("games/game1")
    }

    //private var docRef: DocumentReference!
    //private var quoteListener: ListenerRegistration!
    
    
    @IBAction func buttonAlice(_ sender: UIButton) {
//        let messageToSend = ["player":"Alice", "data": "Connected"]
//        docRef.setData(messageToSend){ error in
//            if let error = error{
//                print("Oh no! Got an error: \(error.localizedDescription)")
//            }else{
//                print("Data has been saved!")
//            }
//        }
    }
    
    @IBAction func buttonBob(_ sender: UIButton) {
//        let messageToSend = ["player":"Bob", "data": "Connected"]
//        docRef.setData(messageToSend){ error in
//            if let error = error{
//                print("Oh no! Got an error: \(error.localizedDescription)")
//            }else{
//                print("Data has been saved!")
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AliceEnterGame" {
                let controller = segue.destination as! GameViewController
            controller.player = "Alice"
            
        }
        if segue.identifier == "BobEnterGame" {
                let controller = segue.destination as! GameViewController
            controller.player = "Bob"
            
        }
    }
    
}


