//
//  ListTVC.swift
//  Trendzz
//
//  Created by Dikshant sharma on 28/07/23.
//

import UIKit
import Kingfisher

class ListTVC: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewTitle: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblSouce: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        setUI()
    }
    
    func setUI(){
        bgView.layer.cornerRadius = 20.0
        imgViewTitle.layer.cornerRadius = 10.0
        bgView.layer.borderWidth = 1.5
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        imgViewTitle.layer.borderWidth = 1.5
        imgViewTitle.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func prepareView(dataModel: Article){
        self.lblTitle.text = dataModel.title ?? ""
        
        if let source = dataModel.source{
            self.lblSouce.text = source == "" ? "N/A" : source
        }else{
            self.lblSouce.text = "N/A"
        }
        if let author = dataModel.author{
            self.lblAuthor.text = author == "" ? "N/A" : author
        }else{
            self.lblAuthor.text = "N/A"
        }
        
        //MARK: Detailed date format
        let publishedAt = dataModel.publishedAt ?? ""
        
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
        
        
        if let imgUrl = dataModel.urlToImage{
            let url = URL(string: imgUrl)
            if(url == nil){
                imgViewTitle.image = UIImage(named: "ic_placeholder")
            }else{
                imgViewTitle.kf.setImage(
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
            imgViewTitle.contentMode = .scaleToFill
            
        }
    }
    
}
