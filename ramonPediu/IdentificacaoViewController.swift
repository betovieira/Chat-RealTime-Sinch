//
//  IdentificacaoViewController.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/7/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import Parse

class IdentificacaoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsername.delegate = self
        txtPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtPassword.resignFirstResponder()
        self.txtUsername.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.txtPassword.resignFirstResponder()
        self.txtUsername.resignFirstResponder()
        return true;
    }
    
    
    @IBAction func clickEntrar(sender: AnyObject) {
        if (txtUsername.text == nil || txtUsername.text == "") ||
        (txtPassword.text == nil) || (txtPassword.text == "")
        {
            self.alertShowView("Digite todos os dados corretamente", texto: "Texto cool")
            
        } else {
            //Singleton.sharedInstance.name = self.txtNome.text
            //Singleton.sharedInstance.receptor = self.txtReceptor.text
            
            if logarUsuario(self.txtUsername.text!, senha: self.txtPassword.text!) {
                let delegateApp = UIApplication.sharedApplication().delegate as! AppDelegate
                delegateApp.initChat(txtUsername.text!)
                
                print("DAORA1 - \(delegateApp.client?.userId)")
                performSegueWithIdentifier("segueProfissionais", sender: sender)
                //alertShowView("Logado com sucesso", texto: "Foi")

                //alertSucess("Logado com sucesso", description: "Logado")

            } else {
                //alertError("Login não existente", description: "")
                alertShowView("Erro Login não existente", texto: "Erro")
            }
            
            
            
            
//            let vc:AnyObject? = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController")
//            self.presentViewController(vc as! UIViewController , animated: true, completion: nil)
            
        }
        
        
    }
    
    func alertShowView(titulo: String, texto: String) {
        let alertController = UIAlertController(title: titulo, message: texto, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /* SYNC - Logar usuário normal */
    func logarUsuario(usuario: String, senha: String) -> Bool {
        do {
            _ = try PFUser.logInWithUsername(usuario, password: senha)
            return true
        } catch {
            return false
        }
        
    }


    @IBOutlet var btnEntrar: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
