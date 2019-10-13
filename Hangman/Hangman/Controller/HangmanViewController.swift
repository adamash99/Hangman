//
//  HangmanViewController
//  Hangman
//
//  Created by David [Entei] Xiong on 2/19/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    var phrases : NSArray!
    var currentWord : String = ""
    var randomIndex : Int = 0
    var model : gameModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // loads possible words
        let path = Bundle.main.path(forResource: "phrases", ofType: "plist")
        phrases = NSArray.init(contentsOfFile: path!)
        
        // initializes model with a random word
        newGame()
        textField.becomeFirstResponder()
    }


    @IBAction func guessLetter(_ sender: Any) {
        let input: String = textField!.text!
        
        // makes sure user dont guess nothing
        if input.count == 0 {
            textField.text = ""
            let alert = UIAlertController(title: "Input Error", message: "Guess a letter", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // makes sure user doesnt guess multiple letters
        if input.count > 1 {
            textField.text = ""
            let alert = UIAlertController(title: "Input Error", message: "You can only guess one letter at a time", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if input.count == 1 {
            let currentChar: Character = Array(input)[0]
            
            //checks if letter has alredy been guessed
            if (model?.guessedLetters.contains(currentChar))! {
                textField.text = ""
                let alert = UIAlertController(title: "Input Error", message: "Character Already Guessed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                //updates model
                model?.guessLetter(letter: currentChar)
                //updates view
                updateView(character: currentChar)
                textField.text = ""
            }
        }
    }
    
    //updates the view when a new character is guessed
    func updateView(character : Character) {
        wordToGuess.text = (model?.formattedWord)
        guessedLetters.text?.append(character)
        guessedLetters.text?.append(" ")
        
        //updates the picture of the hangman
        picture.image = UIImage(named: "hangman" + String(7-model!.guessesLeft))
        
        // checks if game has been won
        if ((model?.gameWon())!) {
            let alert = UIAlertController(title: "You Won", message: "Nice Job!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGameHandler))
            self.present(alert, animated: true, completion: nil)
        }
        
        // checks if game is lost
        if (((model?.gameOver())!)) {
            let alert = UIAlertController(title: "You Lost", message: "You'll get em next time", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGameHandler))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    // initializes model with a random word
    func newGame() {
        textField.text = ""
        randomIndex = Int(arc4random_uniform(UInt32(phrases.count)))
        model = gameModel(word: phrases[randomIndex] as! String)
        wordToGuess.text = (model?.formattedWord)
        guessedLetters.text = "Guessed Letters: "
        picture.image = UIImage(named: "hangman1")
    }
    
    // handler to call newGame function from alert
    func newGameHandler(alert: UIAlertAction!) {
        newGame()
    }
    
    
    // textfield for the user inputted guess
    @IBOutlet weak var textField: UITextField!
    
    //text of the word the user is trying to guess
    @IBOutlet weak var wordToGuess: UILabel!
    
    // text for the letters the user has guessed
    @IBOutlet weak var guessedLetters: UILabel!
    
    // outlet for picutre of the hangman
    @IBOutlet weak var picture: UIImageView!
}

