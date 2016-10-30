//
//  ViewController.swift
//  SpeechRec
//
//  Created by gj on 2016/10/9.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

let questions = ["1.    Were you limited in doing either your work or other daily activities?",
                 "2.    Were you limited in pursuing your hobbies or other leisure time activities?",
                 "3.    Were you shot of breath?",
                 "4.    Have you had pain?",
                 "5.    Did you need to rest?",
                 "6.    Have you had trouble sleeping?",
                 "7.    Have you felt weak?",
                 "8.    Have you lacked appetite?",
                 "9.    Have you felt nauseated?",
                 "10.   Have you vomited?",
                 "11.   Have you been constipated?",
                 "12.   Have you had diarrhea?",
                 "13.   Were you tired?",
                 "14.   Have you had difficulty in concentrating on things, like reading a newspaper or watching television?",
                 "15.   Did you feel tense?",
                 "16.   Did you worry?",
                 "17.   Have you noticed or been told by others that you looked flushed/red?",
                 "18.   Did you have night sweats?",
                 "19.   Have you had aches or pains in your muscles or bones?",
                 "20.   Did you have night sweats?",
                 "21.   Have you had difficulties with eating?",
                 "22.   Have you had acid indigestion or heartburn?",
                 "23.   Have you had side-effects from your treatment?",
                 "24.   How would you rate your overall health during the past week?",
                 "25.   How would you rate your overall quality of life during the past week?"
]


let options = ["ONE","TWO","THREE","FOUR","FIVE","SIX","SEVEN","EIGHT","NINE"]

class ViewController: BaseViewController  {

    var swipeableView = ZLSwipeableView()
    
    var handle:OpenEarsHandle = OpenEarsHandle()
    
    var questionIndex = 0
    
    var hadRec = false  // if already recognize
    var answersForAsk: [Int] = []
    
    deinit {
        handle.stop()
        swipeableView.removeFromSuperview()
        
        SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.loadViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let topview = swipeableView.topView() {
            
            if let card = topview as? CardView {
                let question = card.questionLabel.text!
                self.speakText(question.subString(3, length: question.length - 3))
            }
            
        }
    }
    
    // back
    override func popBack()  {
        handle.stop()
        swipeableView.removeFromSuperview()
    
        SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self, action: #selector(popBack), image: UIImage(named: "back")!)
        self.title = NSDate().convertToShortString()

        view.addSubview(swipeableView)
        
        swipeableView.swiping = {view, location, translation in
            if SSSpeechManager.sharedManager.speechSynthesizer.speaking {
                SSSpeechManager.sharedManager.speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
            }
        }
        
        weak var weakSelf = self
        swipeableView.didSwipe = {view, direction, vector in
            if SSSpeechManager.sharedManager.speechSynthesizer.paused || SSSpeechManager.sharedManager.speechSynthesizer.speaking  {
                SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
            }
            
            delay( 0.5, work: {
                let question = (view as! CardView).questionLabel.text!
                weakSelf!.speakText(question.subString(3, length: question.length - 3))
            })
        }
        
        swipeableView.didCancel = {view in
            if SSSpeechManager.sharedManager.speechSynthesizer.paused {
                SSSpeechManager.sharedManager.speechSynthesizer.continueSpeaking()
            }
        }

        // next data
        swipeableView.nextView = {  [weak self] in
            if self?.questionIndex < questions.count {
                let cardView = CardView(frame: (self?.swipeableView.bounds)!)
                cardView.questionDes = questions[(self?.questionIndex)!]
                
                cardView.backgroundColor = [yijiBackColor, yijiBlue, yijiOrange][(self?.questionIndex)! % 3]
                cardView.replayedBlock = { index in
                    
                    self?.handleReplay(options[index])
                }
                self?.questionIndex += 1
                return cardView
            }
            return nil
        }

        swipeableView.frame  = CGRect(x: 20, y: 30, width: view.width - 40, height: view.height - 70 - 64)
    

        handle.delegate = self
        handle.start()
    }

    // read text
    func speakText(text: String) {
        if !SSSpeechManager.sharedManager.speechSynthesizer.speaking {
            // Check if sharedSpeechManager.languageCodesAndDisplayNames dictionary has entries, if not this means there are no speech voices available on the device. (e.g.: The iPhone Simulator)
            if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0 {
                let speechObject: SSSpeechObject = SSSpeechObject.speechObjectWith(text, language: "en-US", rate: 0.42, pitch: 1.23, volume: 1.0)
                
                SSSpeechManager.sharedManager.speechSynthesizer.delegate = self
                
                SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
            }
        } else {
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
            speakText(text)
        }
    }

    // voice recognition
    func handleReplay(text:  String!)  {
        if options.contains(text) {
            if hadRec {  return }
            hadRec = true
            let index = options.indexOf(text)!
            
            if let card = (self.swipeableView.topView() as? CardView) {
                card.choiseOption(index)
            }
            answersForAsk.append(index+1)
            
            delay(1.0, work: { [weak self] in
                self?.swipeableView.swipeTopView(inDirection: .Left)
                if let _ = self?.swipeableView.topView() {
                    
                } else {
                    self?.handle.stop()
                    self?.hadRec = false
                    self?.saveToDB()
                    
                    self?.pushList()
                }
                
            })
        }

    }

    // save to database
    func saveToDB()  {
        let ans = Answer()
        
        ans.answer = answersForAsk.flatMap { String($0) }.joinWithSeparator(",")
        ans.date = self.title!
        ans.userName  = User.loginUserName
        
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        
        realm.beginWrite()
        realm.add(ans)
        try! realm.commitWrite()
    }
    
    // jumpt to result page
    func pushList()  {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.viewControllers.removeAtIndex(1)
    }
}

extension ViewController: AVSpeechSynthesizerDelegate {
    // speaktext has done
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        handle.resumeListening()
        hadRec = false
    }
    // voice is started
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        handle.suspendListening()
        
    }
    
}

extension ViewController: OpenEarsHandleDelegate {
    // result of voice
    func received(text: String!) {
        handleReplay(text)
    }
}

