//
//  DetailVC.swift
//  Trendzz
//
//  Created by Dikshant Sharma on 02/10/24.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var dataModel:Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DetailVCTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailVCTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        lblTitle.text = "Trendzz"
    }
}

//MARK: TableView delegates
extension DetailVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVCTableViewCell", for: indexPath) as! DetailVCTableViewCell
        if let data = self.dataModel{
            cell.prepareView(data: data)
        }else{
            return UITableViewCell()
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.9) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
