//
//  Config.swift
//  WebRTC-Demo
//
//  Created by Stasel on 30/01/2019.
//  Copyright © 2019 Stasel. All rights reserved.
//

import Foundation
import WebRTC


class Config {
    static let defaultIceServers: [RTCIceServer] = [
        RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"]),
        RTCIceServer(urlStrings: ["stun:stun1.l.google.com:19302"]),
        RTCIceServer(urlStrings: ["stun:stun2.l.google.com:19302"]),
        RTCIceServer(urlStrings: ["stun:stun3.l.google.com:19302"]),
        RTCIceServer(urlStrings: ["stun:stun4.l.google.com:19302"]),
        RTCIceServer(urlStrings: ["stun:157.230.136.8:3478"]),
        RTCIceServer(urlStrings: [
            "turn:157.230.136.8:80?transport=udp",
            "turn:157.230.136.8:3478?transport=udp",
            "turn:157.230.136.8:80?transport=tcp",
            "turn:157.230.136.8:3478?transport=tcp",
            "turns:157.230.136.8:443?transport=tcp",
            "turns:157.230.136.8:5349?transport=tcp"
            ], username: "testuser", credential: "123123")
    ]
    
    static var webRTCIceServers: [RTCIceServer] = [];
    static var signalingServerUrl:String = "157.230.136.8:9092";
}


