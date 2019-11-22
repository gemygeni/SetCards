//
//  ViewController.swift
//  SetCards
//
//  Created by AHMED GAMAL  on 4/13/19.
//  Copyright © 2019 AHMED GAMAL . All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    // MARK: View Controller Properties
    /// Array of UIButton that will show the game elements
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet {
            // update all cards to have rounded corners
            for button in cardButtons {
                button.layer.cornerRadius = 12.0
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.layer.borderWidth = 4.0
            }
        }
    }
    @IBOutlet weak var ScoreLabel: UILabel!{
        didSet{
            ScoreLabel.layer.cornerRadius = 3.0
            ScoreLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ScoreLabel.layer.borderWidth = 4.0
            ScoreLabel.text = "Score : \(setGame.score)"
            
        }
    }
    
    /// Outlet for the Deal Three (3) Cards Button
    @IBOutlet weak var dealThreeCardsButton: UIButton!{
        
        didSet{
            dealThreeCardsButton.layer.cornerRadius = 12.0
            dealThreeCardsButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dealThreeCardsButton.layer.borderWidth = 4.0
        }
    }
    
    /// Outlet for the New Game Button
    @IBOutlet weak var newGameButton: UIButton!{
        didSet{
            newGameButton.layer.cornerRadius = 12.0
            newGameButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            newGameButton.layer.borderWidth = 4.0
            
                    }
    }
    
    /// Outlet for the Find A Set Button
    @IBOutlet weak var findASetButton: UIButton!
    
     /// Holds references to the selected Buttons
    /// Once the count is three, asks the model whether the selection
   /// consists of a set or not, and draws the border accordingly
    private var selectedButtons = [UIButton]() {
        didSet {
            if selectedButtons.count == 3 {
                setWasFound = IsSelectedButtonsFormASet()
selectedButtons.forEach { (button) in button.layer.borderColor = setWasFound ? UIColor.green.cgColor : UIColor.red.cgColor
                    // disable button if a set was found!
                    button.isEnabled = !setWasFound
                }
            }
        }
    }
    
    // MARK: View Model Properties
    /// Pointer to an instance of SetGame, with 81 cards.
    /// See Set for more
    lazy private var setGame = SetGame()
    
    /// Will record whether or not the three cards selected formed a Set
    private var setWasFound = false
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        addEndGameObservers()
    }
    
    // MARK: UIButton Actions
    /// Calls the method `computerFindSet` to show a computer
    /// generated Set in the cards that are currently displayed.
//    @IBAction func findASetButtonDidClick(_ sender: UIButton) {
//        selectedButtons.removeAll()
//        updateViewFromModel()
//        //computerFindSet(startingIndex: 0)
//    }
    
    /// Calls the view method handleTouchOf function
    /// - parameter sender: The UIButton that the user selected
    @IBAction func cardDidTouch(_ sender: UIButton) {
        handleTouchOf(button: sender)
        ScoreLabel.text = "Score : \(setGame.score)"
    }
    
    /// Restarts the game
    @IBAction func newGameButtonDidTouch(_ sender: UIButton) {
        dealThreeCardsButton.isEnabled = true
        //newGameButton.isHidden = true
        setGame.resetGame()
            updateViewFromModel()
         ScoreLabel.text = "Score : \(setGame.score)"
    }
    
    /// Calls the view method dealThreeCards function
    @IBAction func dealThreeCardsButtonDidTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform.identity
        }
        dealThreeCards()
         ScoreLabel.text = "Score : \(setGame.score)"
    }
    
    @IBAction func dealThreeCardsButtonDidTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    // MARK: View Model Actions
    /**
     Updates the current view to show the cards in the Set game model that are
     supposed to be currently shown to user.
     Loops through all indices of the 24 buttons on screen, and checks
     to see if the model has a card available to show on that button. If
     the card is available, it will be shown. If no card exists at that index
     in the model, the button will not be shown & wil be disabled to the user.
     Cards are drawn with no borders.
     */
    func updateViewFromModel() {
        // Loop through all buttons in the collection view
        for (index, button) in cardButtons.enumerated() {
            if index < setGame.cardsShown.count {//to update 12 dealed cards only
                let cardToDisplay = setGame.cardsShown[index]
                let cardFaceString = createAttributedString(using: cardToDisplay)
                button.setAttributedTitle(cardFaceString, for: .normal)
                // Draws all buttons with no borders
                button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
               button.layer.borderWidth = 0.4
               button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.isEnabled = true
            }   else { // for remaining cards in 24 shown cards
                button.backgroundColor = #colorLiteral(red: 0.9461743236, green: 1, blue: 0.2042708695, alpha: 1)
                button.layer.borderWidth = 0.4
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.isEnabled = false
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        }
    }
}
    /**
//     Enables button and draws a gray background so user can see it */
//    func showCardOnButton(_ button: UIButton) {
//        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
//        button.isEnabled = true
//    }
//    /**
//     Disables button and draws a white background so it is hidden */
//    func hideCard(from button: UIButton) {
//        button.backgroundColor = .orange
//        button.layer.borderWidth = 0.4
//        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        button.isEnabled = false
//        button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
//    }
    /**
     Responds to a button being selected by the user. The input is the button that was
     touched by the user.
     */
    func handleTouchOf(button: UIButton) {
        // At this point, nothing new is yet selected.
        // Therefore the `selectedButtons` array will only hold the buttons
        // that had been previously selected. If these formed a set,
        // `setWasFound` would be true, and false otherwise.
        if selectedButtons.count == 3 {
            replaceOrDeselectCards()
        }
        toggleSelectionOfButton(button)
    }
    
    func replaceOrDeselectCards() {
        // no matter what, we're going to be deselecting the buttons that
        // had already been selected.
        selectedButtons.removeAll()
        updateViewFromModel()
    }
    /**
     Removes all buttons from `selectedButtons` array and redraws the View.
     */
    func deselectCardsNotFormingASet() {
        selectedButtons.removeAll()
        updateViewFromModel()
    }
    /**
     Selects or deselects a button based on its previous state
     */
    func toggleSelectionOfButton(_ button: UIButton) {
        if selectedButtons.contains(button) {
            // removes selection border
            button.layer.borderWidth = 0.4
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            // OK to force unwrap because we just checked that selectedButtons
            // contains the button
            selectedButtons.remove(at: selectedButtons.index(of: button)!)
        } else {
            // adds blue border for selection
            button.layer.borderWidth = 4.0
            button.layer.borderColor = UIColor.blue.cgColor
            selectedButtons.append(button)
        }
    }
    /**
     Grabs the card indices by comparing to cardButtons array, and then
     sends the selected buttons to the Set Game. Returns a Bool if the
     user selection corresponds to a Set.
     */
    func IsSelectedButtonsFormASet() -> Bool {
        var selectedCardIndexes = [Int]()
        for button in selectedButtons {
            if let selectedCardIndex = cardButtons.index(of: button) {
                   selectedCardIndexes.append(selectedCardIndex)
            }
        }
        return setGame.inputSelectionWith(indices: selectedCardIndexes)
    }
    
    /*
     * Adds three cards to the view shown to the player, as long
     * as there are less than 24 cards currently being shown.
     */
    func dealThreeCards() {
        let cardsShown = setGame.cardsShown.count
        assert(cardsShown <= 24,
               "ViewController, dealThreeCards(): `cardsShown` is greater than 24")
        
        guard cardsShown < 24 else { return }
        setGame.addThreeCardsToPlay()
        updateViewFromModel()
    }
    
    /*
     * Shows (as highlight) to the user a set that exists in the
     current view. If no set exists, will not highlight any cards.
     Loops through the buttons with a highlight to show the
     user how the calculation runs.
     */
//    private func computerFindSet(startingIndex: Int) {
//        // FUTURE FUNCTIONALITY FOR RECURSIVE FINDING FUNCTION
//         // base case
//         if selectedButtons.count == 3 {
//         return
//         }
//         for buttonIndex in startingIndex..<setGame.cardsShown.count {
//         if setWasFound {
//         print("setWasFound")
//         break }
//         // add the button to `selectedButtons` and continue
//         toggleSelectionOfButton(cardButtons[buttonIndex])
//         computerFindSet(startingIndex: (buttonIndex + 1))
//         toggleSelectionOfButton(cardButtons[buttonIndex])
//         computerFindSet(startingIndex: (buttonIndex + 1))
//         }
//
//    }
    
    /**
     Returns an NSAttributedString object by taking the properties of the input `Card` object
     and converting to a human readable string.
     - parameter card: a `Card` instance.
     */
    let colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
    let shapes = ["\u{25A0}", "\u{25B2}", "\u{25CF}"]
    
    let grayBackgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
    
    private func createAttributedString(using card: Card) -> NSAttributedString {
            var attributes = [NSAttributedString.Key : Any]()
            var cardText: String
            
            attributes[.strokeColor] = colors[card.color] // color
            cardText = String(repeating: shapes[card.symbol], count: card.number + 1)
            
            switch card.shading {
            case 0: attributes[.strokeWidth] = -5.0
            attributes[.foregroundColor] = attributes[.strokeColor]
            case 1: attributes[.foregroundColor] = colors[card.color].withAlphaComponent(0.50)
            case 2: attributes[.strokeWidth] = 5.0
            default: break
            }
            return NSAttributedString(string: cardText, attributes: attributes)
    }
  
    // MARK: End Game Actions & Observers
    @objc private func gameDidEnd() {
        newGameButton.isHidden = false
        dealThreeCardsButton.isEnabled = false
        let alert = UIAlertController(title: "Congratulations!",
                                      message: "You have found all the sets in the deck",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
    private func addEndGameObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameDidEnd),
                                               name: Notification.Name.init("gameDidEnd"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
