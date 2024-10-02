//
//  PresentedByVC.swift
//  Trendzz
//
//  Created by Dikshant sharma on 28/07/23.
//

import UIKit

class PresentedByVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnByTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
