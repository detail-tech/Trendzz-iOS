//
//  DetailVCTableViewCell.swift
//  Trendzz
//
//  Created by Dikshant Sharma on 02/10/24.
//

import UIKit

class DetailVCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblButton: UIButton!
    
    var dataModel: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setui()
    }
    
    @IBAction func lblButtonTapped(_ sender: UIButton) {
        if let dataModel = dataModel{
            if let url = URL(string: dataModel.url ?? "") {
                UIApplication.shared.open(url)
            }
        }else{
            self.showAlertOnRoot(title: "Error in URL", message: "The URL provided seems to be incorrect. Please try after sometime.")
        }
    }
    
    
    func setui(){
        bgView.layer.cornerRadius = 15.0
        imgView.layer.cornerRadius = 15.0
    }
    
    func prepareView(data: Article){
        self.dataModel = data
        lblContent.text = data.content ?? "N/A"
        lblTitle.text = data.title ?? "N/A"//"Details"
        lblButton.setTitle(data.url ?? "", for: .normal)
        if let lblUrlButton = data.url{
            //            lblButton.setTitle(lblUrlButton == "" ? "N/A" : lblUrlButton, for: .normal)
            let buttonText = lblUrlButton
            let attributedString = NSMutableAttributedString(string: buttonText)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: buttonText.count))
            lblButton.setAttributedTitle(attributedString, for: .normal)
        }else{
            lblButton.setTitle("N/A", for: .normal)
        }
        if let desc = data.description{
            self.lblDescription.text = desc == "" ? "N/A" : desc
        }else{
            self.lblDescription.text = "N/A"
        }
        if let content = data.content{
            self.lblContent.text = content == "" ? "N/A" : content
        }else{
            self.lblContent.text = "N/A"
        }
        if let source = data.source{
            self.lblSource.text = source == "" ? "N/A" : source
        }else{
            self.lblSource.text = "N/A"
        }
        if let author = data.author{
            self.lblAuthor.text = author == "" ? "N/A" : author
        }else{
            self.lblAuthor.text = "N/A"
        }
        
        //MARK: Detailed date format
        let publishedAt = data.publishedAt ?? ""
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = isoFormatter.date(from: publishedAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy"
            let formattedDate = outputFormatter.string(from: date)
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let suffix: String
            switch day {
            case 1, 21, 31:
                suffix = "st"
            case 2, 22:
                suffix = "nd"
            case 3, 23:
                suffix = "rd"
            default:
                suffix = "th"
            }
            let finalFormattedDate = formattedDate.replacingOccurrences(of: "\(day)", with: "\(day)\(suffix)")
            lblDate.text = finalFormattedDate
        } else {
            lblDate.text = "N/A"
        }
        
        
        //MARK: Simple date format
        //            let publishedAt = dataModel.publishedAt ?? ""
        //            let isoFormatter = DateFormatter()
        //            isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        //            if let date = isoFormatter.date(from: publishedAt) {
        //                let outputFormatter = DateFormatter()
        //                outputFormatter.dateFormat = "dd/MM/yyyy"
        //                let formattedDate = outputFormatter.string(from: date)
        //                 lblDate.text = finalFormattedDate
        //            } else {
        //                lblDate.text = "N/A"
        //            }
        
        
        if let imgUrl = data.urlToImage{
            let url = URL(string: imgUrl)
            if(url == nil){
                imgView.image = UIImage(named: "ic_placeholder")
            }else{
                imgView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "ic_placeholder"),
                    options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ],
                    completionHandler: { result in
                        switch result {
                        case .success(let value):
                            print("")
                        case .failure(let error):
                            print("")
                        }
                    }
                )
            }
            imgView.contentMode = .scaleToFill
        }
    }
    
    func showAlertOnRoot(title: String, message: String) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = window.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            }
            alert.addAction(okAction)
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
}
