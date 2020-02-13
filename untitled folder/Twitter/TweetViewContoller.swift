//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Brandon Elmore on 2/12/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewContoller: UIViewController {
    
    @IBOutlet weak var tweetText: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.becomeFirstResponder()

    // Do any additional setup after loading the view.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tweet(_ sender: Any) {
        
        
        if(!tweetText.text.isEmpty) {
            TwitterAPICaller.client?.PostTweet(tweetString: tweetText.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
