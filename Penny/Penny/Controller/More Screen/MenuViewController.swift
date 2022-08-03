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
        // Do any additional setup after loading the view.
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .sent:
            print("sent")
        case .saved:
        print("saved")
        case .failed:
        print("failed")
        case .cancelled:
        print("cancelled")
            resultAlert(title: "Title", message: "Cancelled", titleForAction: "OK")
            
        
        default:
            break
        }
    }
    func resultAlert(title: String, message: String, titleForAction: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleForAction, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    private func sendMail(){
        let mailComposeVC =  MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["penny@icloud.com"])
        mailComposeVC.setSubject("Subject")
        mailComposeVC.setMessageBody("Message Body", isHTML: false)
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
                //let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                if !MFMailComposeViewController.canSendMail(){
                    let alert = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return 
                }
            
                break
            default:
                break
            }
        self.sendMail()
        }
    
}
