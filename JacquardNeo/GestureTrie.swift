//
//  GestureTrie.swift
//  JacquardToolkitExample
//
//  Created by Nicholas Cooke on 10/26/19.
//  Copyright © 2019 Caleb Rudnicki. All rights reserved.
//

import Foundation

class GestureNode {
    var children: [String: GestureNode]
    var endOfWord: Bool
    
    init() {
        self.children = [String: GestureNode]()
        self.endOfWord = false
    }
}

class GestureTrie {
    
    var root = GestureNode()
    
    func insert(gestureString: String) {
        self.insert(gestureString, current: self.root, index: 0)
    }
    
    func insert(_ gestureString: String, current: GestureNode, index: Int) {
    if index == gestureString.count {
        current.endOfWord = true
        return
    }
    
    let char = String(Array(gestureString)[index])
    var node = current.children[char]
    if node == nil {
        node = GestureNode()
        current.children[char] = node
    }
    
    self.insert(gestureString, current: node!, index: index + 1)
        
    }
    
    func search(_ word: String) -> Bool {
        var current = self.root
        for char in Array(word) {
            let node = current.children[String(char)]
            if node == nil {
                return false
            }
            current = node!
        }
        return current.endOfWord
    }

    
}
