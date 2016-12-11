//
//  ViewController.swift
//  json2
//
//  Created by TunaYANGIR on 9.12.2016.
//  Copyright © 2016 TunaYANGIR. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var articles:[Article]? = []
    var source = "techcrunch"
override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles(fromSource: source) //fonksiyon çağırma ve link içine veri aktarma
    }
    
    func fetchArticles(fromSource provider:String){    // Fonksiyon tanımlama
        let urlRequest = URLRequest(url:URL(string:"https://newsapi.org/v1/articles?source=\(provider)&sortBy=top&apiKey=aa35d20bb37b43f58aa068076b0a6a26")!) // Json dosyası çekme işlemi ve link içine veri aktarma
        let task = URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in//json session yapıldı
            
            if error != nil{
            print (error)
            return
            }
            self.articles=[Article]()
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                
                if let articlesFromJson = json ["articles"] as? [[String : AnyObject]]{
                    for articlesFromJson in articlesFromJson{
                        let article = Article()
                        if let title = articlesFromJson["title"] as? String,let author = articlesFromJson["author"] as? String,let desc = articlesFromJson["description"] as? String,let url = articlesFromJson["url"] as? String,let imageToUrl=articlesFromJson["urlToImage"]as? String{
                            
                                article.author = author
                                article.desc = desc
                                article.url = url
                                article.headline = title
                                article.imageUrl = imageToUrl
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()

                }
                
            }catch let error {
            print(error)}
            
            
        }
        task.resume()
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        cell.imgView.downloadimage(from: (self.articles?[indexPath.item].imageUrl!)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "web") as! WebviewViewController
        webVC.url=self.articles?[indexPath.item].url
        
        self.present(webVC, animated: true, completion: nil)
    }
    //Menü
    let menuManager = MenuManager()
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVc = self
        
        
    }
//Menü_son





}

extension UIImageView{
    func downloadimage(from url:String){
        let urlRequest = URLRequest(url:URL(string:url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error != nil{
            print(error)
            return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data:data!)
                
            }
        }
        task.resume()
        
    }
}


















