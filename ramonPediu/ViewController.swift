//
//  ViewController.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/6/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SINMessageClientDelegate {
    
    @IBOutlet var tableViewMensagens: UITableView!
    
    @IBOutlet var viewSend: UIView!
    @IBOutlet var messagesTextField: UITextField!
    
    @IBOutlet var btnSend: UIButton!
    var arrayMensagens = [PFObject]()
    var messageClient: SINMessageClient?
    var objectMensagem = PFObject(className: "Mensagem")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        
        self.messagesTextField.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableViewMensagens.dataSource = self
        self.tableViewMensagens.delegate = self
        
        self.messagesTextField.delegate = self
        
        //Carrega as mensagens e desce a tableview
        self.carregaMensagens()
        
        /* Delegate */
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        messageClient = appdelegate.client?.messageClient()
        messageClient?.delegate = self
        
        print("\(Singleton.sharedInstance.name) - \(Singleton.sharedInstance.receptor)")
        
    }
    
    /* Ainda não sei pra que serve */
    func message(message: SINMessage!, shouldSendPushNotifications pushPairs: [AnyObject]!) {
        
    }
    
    /* Quando recebe uma mensagem */
    func messageClient(messageClient: SINMessageClient!, didReceiveIncomingMessage message: SINMessage!) {
        
        /* Se tiver rolando o app em background exibe um push notification */
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            let notification = UILocalNotification()
            
            notification.alertBody = "Mensagem do \(message.recipientIds[0])"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            print("hey1")
            
        }else{
            print(message.senderId)
            
            /* Coloca no banco local as mensagens recebidas */
            objectMensagem = PFObject(className: message.senderId)// Colocaro receptor da mensagem
            objectMensagem.setValue(message.senderId, forKey: "rementente")
            objectMensagem.setValue(PFUser.currentUser()?.username, forKey: "destinatario")
            objectMensagem.setValue(message.text, forKey: "texto")
            objectMensagem.setValue(true, forKey: "enviada")
            objectMensagem.setValue(false, forKey: "recebida")
            objectMensagem.pinInBackgroundWithBlock({(success, error) -> Void in
                if error == nil {
                    print("TA ENTRANDO NESSA PORRA")
                    self.arrayMensagens.append(self.objectMensagem)
                    self.carregaMensagens()
                }
                
            })
            
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
        print("Enviada com sucesso")
        let receptor = Singleton.sharedInstance.receptor
        
        objectMensagem = PFObject(className: receptor)
        objectMensagem.setValue(PFUser.currentUser()?.username, forKey: "remetente")
        objectMensagem.setValue(Singleton.sharedInstance.receptor, forKey: "destinatario")
        objectMensagem.setValue(message.text, forKey:"texto")
        objectMensagem.setValue(true, forKey: "enviada")
        objectMensagem.setValue(false, forKey: "recebida")
        objectMensagem.pinInBackgroundWithBlock({(success, error) -> Void in
            if error == nil {
                print("TA ENTRANDO NESSA PORRA")
                self.arrayMensagens.append(self.objectMensagem)
                self.carregaMensagens()
            }
        
        })
        
        
        
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
        let cell = self.tableViewMensagens.dequeueReusableCellWithIdentifier("MessageCell") as UITableViewCell?
        
        let messageObject = self.arrayMensagens[indexPath.row] 
        
        // Altera a célula
        cell!.textLabel?.text = messageObject["texto"] as? String
        
        //Retorna a celula
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMensagens.count
    }
    
    @IBAction func clickEnviar(sender: AnyObject) {
        
        self.view.layoutIfNeeded()
        
        let message = SINOutgoingMessage(recipient: Singleton.sharedInstance.receptor, text: self.messagesTextField.text!)
        
        
        
        messageClient?.sendMessage(message)
        
        print("manda pro server")
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
            self.messagesTextField.endEditing(true)
            }, completion: nil)
        
    }
    
    func carregaMensagens()
    {
        let usuario = PFUser.currentUser()?.username as String!
        let receptor = Singleton.sharedInstance.receptor

        
        let predicadoRemetente = NSPredicate(format: "remetente = %@ OR destinatario = %@", argumentArray: [usuario, usuario])
        
        let queryTotal = PFQuery(className: receptor, predicate: predicadoRemetente)
        queryTotal.fromLocalDatastore()
        
        /* Pega todos os dados do banco local e preenche de acordo com a pessoa estou conversando */
/*        let queryEnviados = PFQuery(className: receptor)
        queryEnviados.fromLocalDatastore()
//        queryEnviados.whereKey("destinatario", equalTo: Singleton.sharedInstance.receptor)
        queryEnviados.whereKey("remetente", equalTo: (PFUser.currentUser()?.username)!)

        let queryRecebidos = PFQuery(className: receptor)
        queryRecebidos.fromLocalDatastore()
        queryRecebidos.whereKey("destinatario", equalTo: (PFUser.currentUser()?.username)!)
        //queryRecebidos.whereKey("remetente", equalTo: Singleton.sharedInstance.receptor)
        

        let queryFinal = PFQuery.orQueryWithSubqueries([queryEnviados, queryRecebidos])
*/
        print("Eita")
        
        queryTotal.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil {
                print(objects!)
                
                self.arrayMensagens = objects!
                self.tableViewMensagens.reloadData()
                print("Eita1")

                
                if self.arrayMensagens.count > 12 {
                    self.tableViewMensagens.setContentOffset(CGPointMake(0, self.tableViewMensagens.contentSize.height - self.tableViewMensagens.frame.size.height), animated: false)
                }
                
            }
            
        })
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

