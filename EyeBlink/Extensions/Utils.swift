//
//  Utils.swift
//  LiveVideoChat
//
//  Created by Oleksandr Savchenko on 7/4/19.
//  Copyright © 2019 Stas Seldin. All rights reserved.
//

import Foundation
import WebRTC

class Utils{
    static public func loadFacebookProfile(facebookId:String, imageUI:UIImageView){
        let url = URL(string: "https://graph.facebook.com/"+facebookId+"/picture?type=square&width=150&height=150")!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                imageUI.image = UIImage(data: data)
            }
        }
    }
    
    static public func loadProfileImage(imagePath:String, imageUI:UIImageView){
        let url = URL(string: imagePath)!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                imageUI.image = UIImage(data: data)
            }
        }
    }
    
    static private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
