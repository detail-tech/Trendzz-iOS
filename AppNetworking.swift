//
//  AppNetworking.swift
//  Trendzz
//
//  Created by Dikshant sharma on 28/07/23.
//

import Foundation
import Alamofire
import ANActivityIndicator


class AppNetworking{
    static let shared = AppNetworking()
    
    private init(){
        
    }
    
    func getData(input: String, completion: @escaping ([Article]) -> Void, failure: @escaping (String)-> Void){
        print("input text \(input)")
        var todosEndpoint: String = "https://newsapi.org/v2/everything?qInTitle=\(input)&from=2024-09-02&language=en&sortBy=publishedAt&apiKey=658e70f34814444a974230be0e84c5fc"
         todosEndpoint = todosEndpoint.replacingOccurrences(of: "_", with: "%20")
//        qInTitle -> for title specific search
//        q -> for all search
//        api key 1 = b776200c16d843b58a36184d19660e5d
//        api key 2 = 40bcd62e86494e9382587d3672e65003
//        api key 3 = 658e70f34814444a974230be0e84c5fc

        
        AF.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        DispatchQueue.main.async {
                           
                                let response = json as! NSDictionary
                            let status = response["status"] as? String ?? ""
                            if(status == "ok"){
                                let resultArray = response["articles"] as! [NSDictionary]
                                
                                var productArray = [Article]()
                                productArray.removeAll()
                                for element in resultArray{
                                    let author = element["author"] as? String ?? ""
                                    let source = element["source"] as? NSDictionary ?? [:]
                                    let sourceName = source["name"]  as? String ?? ""
                                    let title = element["title"]  as? String ?? ""
                                    let description = element["description"]  as? String ?? ""
                                    let url = element["url"] as? String ?? ""
                                    let urlToImage = element["urlToImage"] as? String ?? ""
                                    let publishedAt = element["publishedAt"]  as? String ?? ""
                                    let content = element["content"] as? String ?? ""
                                    let data = Article(source: sourceName, author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
                                    productArray.append(data)
                                }
                                completion(productArray)
                            }else{
                                ANActivityIndicatorPresenter.shared.hideIndicator()
                                self.showAlertOnRoot(title: "Error", message: "Too many API Requests recently. Try after 24 hours.")
                            }
                        }
                    case .failure(let err):
                        failure(err.localizedDescription)
                    }
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

