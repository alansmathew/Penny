//
//  MenuViewController.swift
//  Penny
//
//  Created by user207265 on 7/27/22.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //making tabBar visable if it is not visable
        tabBarController?.tabBar.isHidden = false
    }

    // differnt states of mail can be tapped while senting a mail
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            print("sent")
            break
        case .saved:
            print("saved")
            break
        case .failed:
        print("failed")
            break
        default:
            break
        }
    }
    
    // Alert function to show messages to user
    func resultAlert(title: String, message: String, titleForAction: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleForAction, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // sending mail to the team
    private func sendMail(){
        let mailComposeVC =  MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["asethunath2390@conestogac.on.ca","tkunnemkerikala3231@conestogac.on.ca","jjoy1824@conestogac.on.ca","amathew2687@conestogac.on.ca","abenoy2025@conestogac.on.ca","avaradan4201@conestogac.on.ca"])
        mailComposeVC.setSubject("FeedBack on Penny App")
        mailComposeVC.setMessageBody("", isHTML: false)
        self.present(mailComposeVC, animated: true, completion: nil)
    }

}

// MARK: - Table Data source

extension MenuViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants().menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let data = Constants().menuItems
        if data.count > indexPath.row{
            cell.textLabel?.text = "\(data[indexPath.row])"
        }
        return cell
    }
    
}

//MARK: - table view delegate
extension MenuViewController : UITableViewDelegate{
    // setting up navigation to different screens using storyBoard Identifier
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
            case 0:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "MainCurrencyViewController") as! MainCurrencyViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 1:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "PasscodeViewController") as! PasscodeViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 2:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 3:
                // this check if its possible to open a realatable mail app to sent email
                if !MFMailComposeViewController.canSendMail(){
                    let alert = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
                else{
                    // this is to sent feedback to our app with mobiles default mail app
                    self.sendMail()
                }
                break
            default:
                break
            }
        }
    
}
