//
//  ListViewController.swift
//  SpeechRec
//
//  Created by gj on 2016/10/12.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit
import RealmSwift
class ListViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    var data: Results<Answer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = User.loginRealName
        
        addNavigationBarLeftButton(self, action: #selector(popBack), image: UIImage(named: "back")!)
    
        table.registerNib("ListCell")
        
        if let _ = data {
            table.reloadData()
        } else {
            getData()
        }
    }
    // database data
    func getData()  {
        let userName = User.loginUserName
        let realm = try! Realm()
        let results = realm.objects(Answer.self).filter(NSPredicate(format:"userName = '\(userName)'"))
        print(results)
        data = results
        table.reloadData()
    }
    
    override func popBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}


// UITable DataSource Delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath] as! ListCell
        let model = data![indexPath.row]
        cell.bind(model)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
