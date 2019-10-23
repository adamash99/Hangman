//
//  gameModel.swift
//  Hangman
//
//  Created by Adam Ash on 10/12/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import Foundation

class gameModel {
    var currentWord: String
    var guessedLetters : [Character]
    var guessesLeft : Int
    
    var formattedWord: String {
        get {
            var formatted = ""
            for char in currentWord {
                guessedLetters.contains(char) || char == " " ? formatted.append(char) : formatted.append(" _ ")
            }
            return formatted
        }
    }
    
    func guessLetter(letter: Character) {
        guessedLetters.append(letter)
        if !currentWord.contains(letter) {
            guessesLeft -= 1
        }
    }
    
    init(word: String) {
        currentWord = word
        guessedLetters = []
        guessesLeft = 6
    }
    
    func gameOver() -> Bool {
        return guessesLeft == 0
    }
    func gameWon() -> Bool {
        for char in currentWord {
            if char != " " && !guessedLetters.contains(char) {
                return false
            }
        }
        return true
        
    }
    
    
    
}
