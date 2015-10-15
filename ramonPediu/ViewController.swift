//
//  ViewController.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/6/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
//import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SINMessageClientDelegate {
    
    @IBOutlet var messageTableView: UITableView!
    
    @IBOutlet var viewSend: UIView!
    @IBOutlet var messagesTextField: UITextField!
    
    @IBOutlet var btnSend: UIButton!
    var messagesArray = [String]()
    var messageClient: SINMessageClient?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        
        self.messagesTextField.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.messagesTextField.delegate = self
        
        
        self.retrieveMessages()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("retrieveMessages"), userInfo: nil, repeats: true)
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
//        appdelegate.client = Sinch.clientWithApplicationKey("9817a69c-8417-4f05-85b4-645eb8b7e2b6", applicationSecret: "KGfkPu4ckk+rdgcRGdXVCQ==", environmentHost: "sandbox.sinch.com", userId: Singleton.sharedInstance.name)
//        
//        appdelegate.client?.setSupportMessaging(true)
//        appdelegate.client?.setSupportCalling(false)
//        appdelegate.client?.setSupportActiveConnectionInBackground(true)

        messageClient = appdelegate.client?.messageClient()
        messageClient?.delegate = self
        print("hey")
        
        print("\(Singleton.sharedInstance.name) - \(Singleton.sharedInstance.receptor)")
        
    }
    
    func message(message: SINMessage!, shouldSendPushNotifications pushPairs: [AnyObject]!) {
        
    }
    
    func messageClient(messageClient: SINMessageClient!, didReceiveIncomingMessage message: SINMessage!) {
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            let notification = UILocalNotification()
            notification.alertBody = "Mensagem do \(message.recipientIds[0])"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            print("hey1")
            
        }else{
            messagesArray.append(message.text)
            self.messageTableView.reloadData()
            print("hey2")
            
        }

    }
        func messageDelivered(info: SINMessageDeliveryInfo!) {
        print("Entregue com sucesso")
            
            
        
    }
    
    func messageFailed(message: SINMessage!, info messageFailureInfo: SINMessageFailureInfo!) {
        print("Erro ao enviar")

    }
    
    
    func messageSent(message: SINMessage!, recipientId: String!) {
        messagesArray.append("\(message.text)")
        self.messageTableView.reloadData()
        print("Enviada com sucesso")
        
        
        /*
            qual a ideia, toda vez que chegar ou enviar alguma mensagem colocar ela em um banco local e salvar no celular, assim, o serviço serviria apenas para se comunicar e fazer com que a mensagem chegue em tempo real
        
        
        
        */

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableViewTapped() {
        self.messagesTextField.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.messagesTextField.resignFirstResponder()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Cria a celula
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as UITableViewCell?
        
        
        // Altera a célula
        cell!.textLabel?.text = self.messagesArray[indexPath.row]
        
        //Retorna a celula
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    @IBAction func clickEnviar(sender: AnyObject) {
        
        self.view.layoutIfNeeded()
        
        //Trava os campos para que não consiga enviar
        self.messagesTextField.enabled = false
        //self.btnSend.enabled = false
        
        let message = SINOutgoingMessage(recipient: Singleton.sharedInstance.receptor, text: self.messagesTextField.text!)
        
        messageClient?.sendMessage(message)

        
        print("manda pro server")
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
            self.messagesTextField.endEditing(true)
            }, completion: nil)
        
    }
    
    func retrieveMessages()
    {
        /*
        let query:PFQuery = PFQuery(className: "Message")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.messagesArray = [String]()
            
            for messageObject in objects! {
                let messageString: String = messageObject["Text"] as! String
                
                if messageString != "" {
                    self.messagesArray.append(messageString)
                }
            }
            
            dispatch_async(dispatch_get_main_queue() ){
                //Atualiza a table view
                self.messageTableView.reloadData()
                
                //Coloca para baixo
                self.messageTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messagesArray.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
            }
        }
        
        //messageTableView.setContentOffset(CGPointZero, animated:true)
        messageTableView.alwaysBounceVertical = true;
        */
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        animateViewMoving(true, moveValue: 255)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        animateViewMoving(false, moveValue: 255)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
}

