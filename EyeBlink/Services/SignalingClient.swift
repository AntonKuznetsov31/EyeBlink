//
//  SignalClient.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import Foundation
import SwiftyJSON
import WebRTC
import Starscream

protocol SignalClientDelegate: class {
    func signalClientDidConnect(_ signalClient: SignalingClient)
    func signalClientDidDisconnect(_ signalClient: SignalingClient)
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription)
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate)
    func signalClient(_ signalClient: SignalingClient, command: String)
}

final class SignalingClient {
    
    private let socket: WebSocket
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    weak var delegate: SignalClientDelegate?
    
    init(serverUrl: URL) {
        debugPrint("url: \(serverUrl)")
        self.socket = WebSocket(url: serverUrl)
    }
    
    func connect() {
        self.socket.delegate = self
        self.socket.connect()
    }
    
    func sendData(_ data:Dictionary<String, String?>){
        print("sendData")
        do {
            let dataMessage = try self.encoder.encode(data)
            
            //debugPrint(dataMessage);
            self.socket.write(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not send register() \(error)")
        }
    }
    
    func register(){
        let uuid = UIDevice.current.identifierForVendor!.uuidString;
        
        let message = [
            "type": "register",
            "uid": uuid,
        ]
        
        sendData(message);
    }
    
    func stop(){
        let message = [
            "type": "stop"
        ]
        sendData(message);
    }
    
    func next(){
        let message = [
            "type": "next"
        ]
        sendData(message);
    }
    

    func send(sdp rtcSdp: RTCSessionDescription) {
        let message = Message.sdp(SessionDescription(from: rtcSdp))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.socket.write(string: fixSdp(data: dataMessage))
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }
    }
    
    func fixSdp(data: Data)->String{
        print("fix");
        var message:String = "";
        do {
            let json = try JSON(data: data)
            
            //json["type"] = "localDescription"
            //json.dictionaryObject?.switchKey(fromKey: "payload", toKey: "description")
            
            //convert the JSON to a raw String
            message = json.rawString()!
        } catch {
            debugPrint("Warning: fixSdp cant decode sdp: \(error)")
            // or display a dialog
        }
        print(message)
        return message;
    }
    
    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        let message = Message.candidate(IceCandidate(from: rtcIceCandidate))
        do {
            let dataMessage = try self.encoder.encode(message)
            //self.socket.write(data: dataMessage)
            self.socket.write(string: fixIceCandidate(data: dataMessage))
        }
        catch {
            debugPrint("Warning: Could not encode candidate: \(error)")
        }
    }
    
    func fixIceCandidate(data: Data)->String{
        var message:String = "";
        do {
            var json = try JSON(data: data)
            json["hasStream"] = true;
            
            //json.dictionaryObject?.switchKey(fromKey: "payload", toKey: "candidate")
            //json["candidate"].dictionaryObject?.switchKey(fromKey: "sdp", toKey: "candidate")
            //json["candidate"].dictionaryObject?.switchKey(fromKey: "sdpMLineIndex", toKey: "label")
            //json["candidate"].dictionaryObject?.switchKey(fromKey: "sdpMid", toKey: "id")
            
            //convert the JSON to a raw String
            message = json.rawString()!
        } catch {
            debugPrint("Warning: fixIceCandidate cant decode: \(error)")
            // or display a dialog
        }
        return message;
    }
    
    
   
}


extension SignalingClient: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.signalClientDidConnect(self);
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.delegate?.signalClientDidDisconnect(self)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        let message: Message
        do {
            message = try self.decoder.decode(Message.self, from: data)
        }
        catch {
            debugPrint("Warning: Could not decode incoming message: \(error)")
            return
        }
        
        
        switch message {
        case .candidate(let iceCandidate):
            self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
        case .sdp(let sessionDescription):
            self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        debugPrint(text);
        
        if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
            do {
                var json = try JSON(data: dataFromString)
                
                print(json["type"])
             
                
                if (json["type"] == "onVideoData"){
                    if (json["candidate"].exists()){
                        
                        json["candidate"].dictionaryObject?.switchKey(fromKey: "candidate", toKey: "sdp")
                        //json["candidate"].dictionaryObject?.switchKey(fromKey: "label", toKey: "sdpMLineIndex")
                        //json["candidate"].dictionaryObject?.switchKey(fromKey: "id", toKey: "sdpMid")
                        //json["type"] = "IceCandidate";
                        
                        json.dictionaryObject?.switchKey(fromKey: "candidate", toKey: "payload")
                        
                        //websocketDidReceiveData(socket: socket, data: try json.rawData())
                    }
                    
                    if (json["description"].exists()){
                        json.dictionaryObject?.switchKey(fromKey: "description", toKey: "payload")
                        //json["type"] = "SessionDescription"
                        
                        //websocketDidReceiveData(socket: socket, data: try json.rawData())
                    }
                }
                
                 if (json["type"] == "IceCandidate"){
                     websocketDidReceiveData(socket: socket, data: try json.rawData())
                 }
                 if (json["type"] == "SessionDescription"){
                     websocketDidReceiveData(socket: socket, data: try json.rawData())
                 }
                
                
                
                if (json["type"] == "onBeginDialog"){
                    self.delegate?.signalClient(self, command:"onBeginDialog")
                    
                    print ("isCaller: \(json["isCaller"])");
                    
                    if (json["isCaller"] == "true"){
                        self.delegate?.signalClient(self, command:"sendOffer")
                    }
                }
                
                if (json["type"] == "onByeBye"){
                    self.delegate?.signalClient(self, command:"onByeBye")
                }
            }catch{
                print("websocketDidReceiveMessage error:");
                debugPrint(error);
            }
        }
    }
}
