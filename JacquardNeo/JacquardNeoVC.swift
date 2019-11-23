//
//  JacquardNeoVC.swift
//  JacquardNeo
//
//  Created by Michael on 11/23/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import UIKit
import JacquardToolkit

class JacquardNeoVC: UIViewController {
        
    var string = ""
    var threadArray: [UIView] = {
        var result: [UIView] = []
        for i in 0...14 {
            let v = UIView()
            v.alpha = 0.3
            v.backgroundColor = .black
            v.layer.cornerRadius = 6
            v.translatesAutoresizingMaskIntoConstraints = false
            result.append(v)
        }
        return result
    }()
    var threadChunkArray: [[Float]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Jacquard"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        JacquardService.shared.delegate = self
        rainbowGlowButton.addTarget(self, action: #selector(rainbowGlowButtonTapped), for: .touchUpInside)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        setup()
    }
    
    // UI Components
    
    var threadsLabel: UILabel = {
        let l = UILabel()
        l.text = "Threads"
        l.font = UIFont.systemFont(ofSize: 24, weight: .light)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var threadsLabelUnderline: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var hStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillEqually
        v.spacing = 24
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var gestureLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 48, weight: .medium)
        l.text = "GESTURE"
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var connectButton: UIButton = {
        let b = UIButton()
        b.setTitle("Connect", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    var rainbowGlowButton: UIButton = {
        let b = UIButton()
        b.setTitle("Rainbow Glow", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = .systemPink
        b.setTitleColor(.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    
    // Logic Functions
    
    func setup() {
//        view.addSubview(threadsLabel)
//        view.addSubview(threadsLabelUnderline)
        for thread in threadArray {
            thread.heightAnchor.constraint(equalToConstant: 12).isActive = true
            stackView.addArrangedSubview(thread)
        }
        view.addSubview(stackView)
        view.addSubview(gestureLabel)
        
        hStackView.addArrangedSubview(connectButton)
        hStackView.addArrangedSubview(rainbowGlowButton)
        view.addSubview(hStackView)
        
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        gestureLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 64).isActive = true
        gestureLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        gestureLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        hStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        hStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        hStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
        
    @objc func connectButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.connectButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.connectButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        if !JacquardService.shared.isJacquardConnected() {
            JacquardService.shared.activateBluetooth { _ in
                guard self.navigationController != nil else {
                    JacquardService.shared.connect(viewController: self)
                    return
                }
                JacquardService.shared.connect(viewController: self.navigationController!)
            }
        }
    }
    
    @objc func rainbowGlowButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.rainbowGlowButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.rainbowGlowButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        JacquardService.shared.rainbowGlowJacket()
    }
    
    func groupDetector(input: inout [[Float]]) -> String {
            
        var output: [Float] = [0.0, 0.0, 0.0]
        for i in 0..<input.count {
            for j in 0..<input[i].count {
                dfs(input: &input, i: i, j: j, output: &output)
            }
        }
    
        let maxValue = output.max() != 0 ? output.max() : -1
        switch output.index(of: maxValue!) {
        case 0:
            self.gestureLabel.text = "RIGHT"
            return "Right"
        case 1:
            self.gestureLabel.text = "CENTER"
            return "Center"
        case 2:
            self.gestureLabel.text = "LEFT"
            return "Left"
        default:
            break
        
        }
        
        return ""
    }
        
    func dfs(input: inout [[Float]], i: Int, j: Int, output: inout [Float]) {
        if i >= 0 && i < input.count && j >= 0 && j < input[i].count && input[i][j] != 0 {
            
            if j <= 5 {
                output[0] += 1
            } else if j <= 10 {
                output[1] += 1
            } else {
                output[2] += 1
            }
            
            input[i][j] = 0
            dfs(input: &input, i: i + 1, j: j, output: &output)
            dfs(input: &input, i: i - 1, j: j, output: &output)
            dfs(input: &input, i: i, j: j + 1, output: &output)
            dfs(input: &input, i: i, j: j - 1, output: &output)

        }
    }
    
}

extension JacquardVC: JacquardServiceDelegate {
    
    func didDetectDoubleTapGesture() {
        gestureLabel.text = "Double Tap"
    }
        
    func didDetectBrushInGesture() {
        gestureLabel.text = "Brush In"
    }
    
    func didDetectBrushOutGesture() {
        gestureLabel.text = "Brush Out"
    }
    
    func didDetectCoverGesture() {
        gestureLabel.text = "Cover"
    }
    
    func didDetectScratchGesture() {
        gestureLabel.text = "Scratch"
    }
    
    func didDetectForceTouchGesture() {
        gestureLabel.text = "Force Touch"
    }
    
    func didDetectThreadTouch(threadArray: [Float]) {
        
        if threadChunkArray.count == 5 {
            let group = groupDetector(input: &threadChunkArray)
            print(group + "\n")
//            if string.count < 3 {
//                if group != "" {
//                    if string.last != Character(group) {
//                        string.append(Character(group))
//                    }
//                }
//            } else {
//                print(string)
//                string = ""
//            }
            threadChunkArray.removeAll(keepingCapacity: false)
        } else {
            threadChunkArray.append(threadArray)
        }
        
        // print(threadArray)
        for (thread, threadValue) in zip(self.threadArray, threadArray) {
            if threadValue > 0 {
                UIView.animate(withDuration: 0.1) {
                    thread.alpha = 1
                    thread.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    thread.alpha = 0.3
                    thread.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
            
        }
    }
    
    func didDetectConnection(isConnected: Bool) {
        connectButton.setTitle(isConnected ? "Connected" : "Connect", for: .normal)
        connectButton.isEnabled = !isConnected
        rainbowGlowButton.isEnabled = isConnected
        for thread in threadArray {
            thread.alpha = isConnected ? 1.0 : 0.3
        }
    }

}
