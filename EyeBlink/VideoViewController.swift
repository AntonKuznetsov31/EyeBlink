//
//  VideoViewController.swift
//  WebRTC
//
//  Created by Stasel on 21/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import WebRTC

class VideoViewController: UIViewController {
    private var localCandidates: [RTCIceCandidate] = [];
    
    private var signalClient: SignalingClient?
    private var webRTCClient: WebRTCClient?
    
    @IBOutlet weak var muteSwitch: UISwitch!
    
    @IBOutlet private weak var localVideoView: UIView?
    
    @IBOutlet weak var backVideoView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.text = "";
       log("start")
       signalClient = SignalingClient(serverUrl: URL(string: "ws://"+Config.signalingServerUrl)!);
       signalClient?.delegate = self;
       signalClient?.connect();
       log("try connect to signaling server");
        
        
       muteSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        resetWebRTC()
    }
    
    func log(_ msg:String){
        print(msg);
        //textView.text += msg + "\n";
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        changeMute();
    }
    
    func changeMute(){
        if muteSwitch.isOn {
            if (webRTCClient != nil){
                webRTCClient?.muteAudio();
            }
        } else {
            if (webRTCClient != nil){
                webRTCClient?.unmuteAudio();
            }
        }
    }
    
    
    func showPartnerVideo(){
        log("ALL OK. SHOW PARTNER VIDEO");
        
        self.webRTCClient?.speakerOn();
        playRemoteVideo();
        
        changeMute();
    }
    
    func sendCandidates(){
       for candidate in self.localCandidates {
           print("send local candidate");
           self.signalClient?.send(candidate: candidate)
       }
   }
    
    func sendOffer(){
        self.webRTCClient?.offer { (sdp) in
            self.signalClient?.send(sdp: sdp)
            self.sendCandidates();
        }
    }
    
    func sendAnswer(){
        self.webRTCClient?.answer { (localSdp) in
            self.signalClient?.send(sdp: localSdp)
            self.sendCandidates();
        }
    }
    
    private func playRemoteVideo(){
        #if arch(arm64)
        let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
        remoteRenderer.videoContentMode = .scaleAspectFill
        #else
        let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif
        
        self.webRTCClient?.renderRemoteVideo(to: remoteRenderer)
        
        self.embedView(remoteRenderer, into: self.backVideoView)
    }

    private func playLocalVideo(){
        #if arch(arm64)
        // Using metal (arm64 only)
        let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
        //let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
        localRenderer.videoContentMode = .scaleAspectFill
        //remoteRenderer.videoContentMode = .scaleAspectFill
        #else
        // Using OpenGLES for the rest
        let localRenderer = RTCEAGLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
        //let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif
        
        self.webRTCClient?.startCaptureLocalVideo(renderer: localRenderer)
        //self.webRTCClient?.renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            //self.embedView(localRenderer, into: localVideoView)
        }
    }
    
    func resetWebRTC(){
        // remove previous webrtc delegate events
        if let webrtc = self.webRTCClient{
            webrtc.delegate = nil;
            webrtc.dispose();
        }
        //localCandidates = [];
        
        for view in self.backVideoView!.subviews {
            view.removeFromSuperview()
        }
    
        for view in self.localVideoView!.subviews {
           view.removeFromSuperview()
        }
        
        
        self.webRTCClient = WebRTCClient(iceServers: Config.defaultIceServers);
        self.webRTCClient?.delegate = self;
        
        
        playLocalVideo();
    }
    
    func onPartnerDisconnect(){
        print("onPartnerDisconnect()");
        
        resetWebRTC()
    }

    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view);
        
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated);
    }
}



extension VideoViewController: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        self.log("webrtc: discovered local candidate");
        //localCandidates.append(candidate);
        self.signalClient?.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        print(">>>>>>> webRTCClient   \(state)");
        self.log("webrtc new state: \(state)");
        
         DispatchQueue.main.async {
            switch state {
                case .connected, .completed:
                    self.showPartnerVideo();
                case .disconnected:
                    self.onPartnerDisconnect();
                case .failed, .closed:
                    self.onPartnerDisconnect();
                case .new, .checking, .count:
                    break;
            }
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        DispatchQueue.main.async {
            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension VideoViewController: SignalClientDelegate {
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        log("signaling server: connect complete");
        
        self.signalClient?.register();
        log("signaling server: do register()");
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient){
        log("signaling server: did disconnect");
    }
   func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        log("signaling server: Received remote sdp");
    
        self.webRTCClient?.set(remoteSdp: sdp) { (error) in
            self.sendAnswer();
        }
    }
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        log("signaling server: Received remote candidate");
        
        self.webRTCClient?.set(remoteCandidate: candidate)
    }
    
    // onBeginDialog
    func signalClient(_ signalClient: SignalingClient, command:String){
        DispatchQueue.main.async {
            if (command == "onBeginDialog"){
                self.log("signaling server: DIALOG BEGIN");
            }
            if (command == "sendOffer"){
                self.log("signaling server: Send Offer");
                
                self.sendOffer();
            }
            
            if (command == "sendAnswer"){
                self.log("signaling server: send answer");
                
                self.sendAnswer();
            }
            
            if (command == "onByeBye"){
                self.log("signaling server: partner disconnect");
                
                self.onPartnerDisconnect();
            }
        }
    }
}
