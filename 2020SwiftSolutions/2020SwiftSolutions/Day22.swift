//
//  Day22.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 24/06/2021.
//

import Foundation
import DequeModule
import PuzzleBox

class Day22 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day22Input.txt")
    }
    
    var startState : GameState {
        GameState(inputText: inputStringUnparsed!, deckSize: 25)
    }
    
    func part1() {
        var state = startState
        
        while !state.isGameOver {
            state.oneRoundPart1()
        }
        
        print(max(state.player1.deckValue, state.player2.deckValue))
    }
    
    func part2() {
        print(
            getRecursiveCombatWinnerAndDeck(startState: startState).1.deckValue
        )
    }
    
    private func getRecursiveCombatWinnerAndDeck(startState : GameState) -> (Int, Deque<Int>) {
        var localGameState = startState
        var previousStates = Set<GameState>()
        
        while !localGameState.isGameOver {
            if previousStates.contains(localGameState) {
                return (1,localGameState.player1)
            } else {
                previousStates.insert(localGameState)
            }
            
            let cards = localGameState.drawCards()
            let winner = getWinnerOfRound(cards: cards, currentGameState: localGameState)
            localGameState.updateAfterWinner(cards: cards, winner: winner)
        }
        
        return localGameState.winner
    }
    
    private func getWinnerOfRound(cards : (Int,Int), currentGameState : GameState) -> Int {
        let (card1, card2) = cards
        
        if currentGameState.canDoRecursiveCombat(card1: card1, card2: card2) {
            let trimmedMiniGame = currentGameState.trimmedGame(card1: card1, card2: card2)
            return getRecursiveCombatWinnerAndDeck(startState: trimmedMiniGame).0
        } else {
            return card1 < card2 ? 2 : 1
        }
    }
    
}

struct GameState : Hashable {
    
    var player1 : Deque<Int>
    var player2 : Deque<Int>
    
    init(inputText : String, deckSize : Int) {
        let decks = inputText.components(separatedBy: "\n").compactMap { Int($0) }.chunked(into: deckSize)
        
        self.player1 = Deque(decks[0])
        self.player2 = Deque(decks[1])
    }
    
    private init(player1: Deque<Int>, player2: Deque<Int>) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func trimmedGame(card1 : Int, card2 : Int) -> GameState {
        GameState(player1: Deque(player1.prefix(card1)), player2: Deque(player2.prefix(card2)))
    }
    
    mutating func updateAfterWinner(cards : (Int,Int), winner : Int) {
        let (card1, card2) = cards
        
        if winner == 1 {
            player1.append(card1)
            player1.append(card2)
        } else {
            player2.append(card2)
            player2.append(card1)
        }
    }
    
    mutating func drawCards() -> (card1 : Int, card2 : Int) {
        (player1.popFirst()!, player2.popFirst()!)
    }
    
    mutating func oneRoundPart1() {
        let card1 = player1.popFirst()!
        let card2 = player2.popFirst()!
        
        if card1 > card2 {
            player1.append(card1)
            player1.append(card2)
        } else {
            player2.append(card2)
            player2.append(card1)
        }
    }
    
    var winner : (Int, Deque<Int>) {
        player2.isEmpty ? (1, player1) : (2, player2)
    }
    
    var isGameOver : Bool {
        player1.isEmpty || player2.isEmpty
    }
    
    func canDoRecursiveCombat(card1 : Int, card2 : Int) -> Bool {
        card1 <= player1.count && card2 <= player2.count
    }
}

extension GameState: CustomStringConvertible {
    var description: String {
        "\(player1) vs \(player2)"
    }
}

extension Collection where Element == Int {
    var deckValue : Int {
        self.reversed().enumerated().reduce(0, { acc, next in
            let (index, card) = next
            return acc + (index + 1)*card
        })
    }
}
