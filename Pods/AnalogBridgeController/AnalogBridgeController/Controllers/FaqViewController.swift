//
//  FaqViewController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import JGProgressHUD

class FaqViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var hud:JGProgressHUD!
    var faqArray:[Faq] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 69
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        APIService.sharedService.getFaqs(completion: {
            array in
            self.faqArray = array!
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hud.dismiss()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FaqViewCell = tableView.dequeueReusableCell(withIdentifier: "faqViewCell", for: indexPath) as! FaqViewCell
        setupCell(cell: cell, at: indexPath)
        
        return cell
    }
    
    func setupCell(cell:FaqViewCell, at indexPath:IndexPath) {
        let faq = faqArray[indexPath.row]
        cell.questionLabel.text = faq.question
        cell.answerLabel.text = faq.answer
    }
}
