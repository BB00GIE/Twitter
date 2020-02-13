//
//  TweetsCell.swift
//  Twitter
//
//  Created by Brandon Elmore on 2/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var favorited: Bool = false
    var tweetId: Int = -1
    var retweeted: Bool = false
    
    func setFavorited(_ isFavorited: Bool){
        favorited = isFavorited
        if(favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        if(isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    @IBAction func Favorite(_ sender: Any) {
        
        let toBeFavorited = !favorited
        if(toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        }
            else {
                TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                    self.setFavorited(false)
                }, failure: { (error) in
                    print("Unfavorite did not succeed: \(error)")
                
                })
        }
    }
        
    
    
    
    @IBAction func Retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Retweet did not succeed: \(error)")
        })
    }
    
}
