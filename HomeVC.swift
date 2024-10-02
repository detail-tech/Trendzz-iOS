//
//  HomeVC.swift
//  Trendzz
//
//  Created by Dikshant Sharma on 28/07/23.
//

import UIKit
import ANActivityIndicator


class HomeVC: UIViewController {
    
    @IBOutlet weak var btnBy: UIButton!
    @IBOutlet weak var btnFind: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFieldInput: UITextField!
    
    @IBOutlet weak var imgSearchErrorView: UIImageView!
    var dataArray = [Article]()
    var inputCategory = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
        
    }
    
    private func setUI(){
        lblHeading.text = "Trendzz"
        btnFind.layer.backgroundColor = UIColor(red: 180/255.0, green: 150/255.0, blue: 187/255.0, alpha: 1.0).cgColor
        btnFind.layer.cornerRadius = 5.0
        btnBy.layer.backgroundColor = UIColor(red: 180/255.0, green: 150/255.0, blue: 187/255.0, alpha: 1.0).cgColor
        btnBy.layer.cornerRadius = 5.0
        btnClear.layer.backgroundColor = UIColor(red: 180/255.0, green: 150/255.0, blue: 187/255.0, alpha: 1.0).cgColor
        btnClear.layer.cornerRadius = 5.0
        imgSearchErrorView.isHidden = true
        
    }
    
    private func setTableView(){
        tblView.register(UINib(nibName: "ListTVC", bundle: nil), forCellReuseIdentifier: "ListTVC")
    }
    
    
    
    @IBAction func btnByTapped(_ sender: UIButton) {
        let str = UIStoryboard(name: "Main", bundle: nil)
        let scene = str.instantiateViewController(withIdentifier: "PresentedByVC") as! PresentedByVC
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
    
    @IBAction func btnFind(_ sender: UIButton) {
        guard let text = txtFieldInput.text else {return}
        txtFieldInput.resignFirstResponder()
        if(text.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Kindly Input data in the textfield first and than click on Find button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                default:
                    print("default")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.dataArray.removeAll()
            self.tblView.reloadData()
            self.imgSearchErrorView.isHidden = true
            ANActivityIndicatorPresenter.shared.showIndicator()
            AppNetworking.shared.getData(input: text.replacingOccurrences(of: " ", with: "_")) { productArray in
                ANActivityIndicatorPresenter.shared.hideIndicator()
                self.dataArray.removeAll()
                self.dataArray = productArray
                self.imgSearchErrorView.isHidden = !self.dataArray.isEmpty
                self.tblView.reloadData()
                self.tblView.setContentOffset(.zero, animated: false)
                
            } failure: { err in
                self.imgSearchErrorView.isHidden = false

                ANActivityIndicatorPresenter.shared.hideIndicator()
                let alert = UIAlertController(title: "API Error", message: "Try again Later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    default:
                        print("default")
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            txtFieldInput.text = ""
        }
    }
    
    @IBAction func btnClearTapped(_ sender: UIButton) {
        self.dataArray.removeAll()
        self.tblView.reloadData()
        self.txtFieldInput.text = ""
        self.imgSearchErrorView.isHidden = true

    }
}

//MARK: TableView delegates
extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath) as! ListTVC
        cell.prepareView(dataModel: dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.9) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scene = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        scene.dataModel = self.dataArray[indexPath.row]
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
    
}
