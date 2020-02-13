 //
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Brandon Elmore on 2/6/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberofTweets: Int!
    let myRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberofTweets = 20
        self.loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        
        numberofTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParameters = ["count": numberofTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl , parameters: myParameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                
                self.tweetArray.append(tweet)
                
            }
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            
            print("could not retrieve tweets! oh no!")
            
        })
    }
    
    
    
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberofTweets = numberofTweets + 20
        let myParam = ["count": numberofTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl , parameters: myParam, success: { (tweets: [NSDictionary]) in
               
               self.tweetArray.removeAll()
               
               for tweet in tweets {
                   
                   self.tweetArray.append(tweet)
                   
               }
               
               self.tableView.reloadData()
               
               self.myRefreshControl.endRefreshing()
           }, failure: { (Error) in
               
               print("could not retrieve tweets! oh no!")
               
           })
        
    }
  

    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetsCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.ProfilePic.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        cell.retweeted = tweetArray[indexPath.row]["retweeted"] as! Bool
        
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
        
    }

   
}
