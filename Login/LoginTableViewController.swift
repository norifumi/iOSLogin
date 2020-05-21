//
//  LoginTableViewController.swift
//  Login
//
//  Created by NORIFUMI HOMMA on 2020/05/06.
//  Copyright © 2020 init6. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    var sessionCreate: SessionController = SessionController(user: User())
    var sessionAPIObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var user = User()
        user.email = "taro.appium@example.com"
        user.password = "p@ssw0rd"
        sessionCreate = SessionController(user: user)
        
        sessionAPIObserver = NotificationCenter.default.addObserver(forName: .sessionAPIComplete, object: nil, queue: nil, using: {
            (notification) in
            print("APIリクエスト完了")
            if notification.userInfo != nil {
                if let userInfo = notification.userInfo as? [String: String?] {
                    if userInfo["error"] != nil {
                        print(userInfo["error"]!!)
                        let alertView = UIAlertController(title: "エラー", message: "ログインに失敗しました", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .default) {
                            action in return
                        })
                        self.present(alertView, animated: true, completion: nil)
                    } else {
                        print(userInfo["idAccessToken"])
                        NameTextView().insertText("uattta-")
                        self.performSegue(withIdentifier: "PushDashboard", sender: self)
                    }
                }
            }
        })
        
        sessionCreate.create()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let email_cell = tableView.dequeueReusableCell(withIdentifier: "Email") as! EmailTableViewCell
        let password_cell = tableView.dequeueReusableCell(withIdentifier: "Password") as! PasswordTableViewCell
        
        // Configure the cell...
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return email_cell
            } else {
                return password_cell
            }
        }
        return UITableViewCell()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
