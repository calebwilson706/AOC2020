//
//  Day10.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 30/05/2021.
//

import Foundation
import PuzzleBox

class Day10 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day10Input.txt")
    }
    
    var numbers : [Int] {
        inputStringUnparsed!.components(separatedBy: .newlines).map { Int($0)! }.sorted()
    }
        
    func part1() {
        let differences = findVoltageDifferences(theList: numbers)
        
        print(differences[1]!*differences[3]!)
    }
    
    func part2() {
        var dict = [0:1]
        
        for number in numbers {
            dict[number] = dict[number - 1, default : 0] + dict[number - 2, default: 0] + dict[number - 3, default: 0]
        }
        
        print(dict[numbers.last!]!)
    }
    
    func findVoltageDifferences(theList : [Int]) -> [Int : Int]{
        var myCountOfDifferences : [Int : Int] = [:]
        (1...3).forEach { myCountOfDifferences[$0] = 0 }
        
        
        (0 ..< theList.count - 1).forEach { index in
            let difference = theList[index+1] - theList[index]
            myCountOfDifferences[difference]! += 1
        }
        
        myCountOfDifferences[theList.first! - 0]! += 1
        myCountOfDifferences[3]! += 1
        
        return myCountOfDifferences
    }
}


