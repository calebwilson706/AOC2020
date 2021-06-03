//
//  Day19.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 02/06/2021.
//

import Foundation
import PuzzleBox
import DequeModule


class Day19 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day19Input.txt")
    }
    
    var lines : [String] {
        inputStringUnparsed!.components(separatedBy: .newlines)
    }
    
    func part1() {
        let validStrings = Day19RuleParser().parse()["0"]!
        print(lines.filter { validStrings.contains($0) }.count)
    }
    
    func part2() {
        let map = Day19RuleParser().parse()
        
        let startPatterns = map["42"]!
        let endPatterns = map["31"]!
        
        let valid = lines.filter { string in
            if string.count % 8 != 0 {
                return false
            }
            let chunks = [Character](string).chunked(into: 8).map { String($0) }
            
            return
                chunks.allSatisfy { startPatterns.contains($0) || endPatterns.contains($0) }
                && chunks.filter { endPatterns.contains($0) }.count < chunks.filter { startPatterns.contains($0) }.count
                && (chunks.lastIndex(where: { startPatterns.contains($0) })! < chunks.firstIndex(where: { endPatterns.contains($0) }) ?? -1)
               
        }
        
        
        
        print(valid.count)
    }
    
}


class Day19RuleParser : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day19Rules.txt")
    }
    
    func parse() -> [String : Set<String>] {
        let lines = inputStringUnparsed!.components(separatedBy: .newlines)
        var foundRules = getInitialFoundRules(lines: lines)
        
        
        while (foundRules.count != lines.count) {
            let thoseToParse = lines.filter { rule in
                !foundRules.keys.contains(rule.ruleNumber) && rule.requiredRules.allSatisfy { foundRules.keys.contains($0) }
            }
            
            thoseToParse.forEach {
                foundRules[$0.ruleNumber] = getPossibilities(ruleString: $0, existingRules: foundRules)
            }
        }
            
        
        
       return foundRules
        
    }
    
    func getInitialFoundRules(lines : [String]) -> [String : Set<String>] {
        let starters = lines.filter { $0.contains("\"") }
        var result = [String : Set<String>]()
        
        starters.forEach {
            let parts = $0.filter { char in char != "\"" }.components(separatedBy: ": ")
            result[parts.first!] = Set(arrayLiteral: parts.last!)
        }
        
        return result
    }
    
    
    func getPossibilities(ruleString : String, existingRules : [String : Set<String>]) -> Set<String> {
        if !ruleString.contains("|") {
            return parseSingleRulePattern(requiredForRule: ruleString.requiredRules, existingRules: existingRules)
        } else {
            let options = ruleString.ruleChildrenString.components(separatedBy: " | ")
            return options.reduce(Set<String>()) { acc, nextRuleParts in
                acc.union(parseSingleRulePattern(requiredForRule: nextRuleParts.components(separatedBy: " "), existingRules: existingRules))
            }
        }
    }
    
    func parseSingleRulePattern(requiredForRule : [String], existingRules : [String : Set<String>]) -> Set<String> {
        let firstRule = requiredForRule.first!
        let optionsForFirst = existingRules[firstRule]!
        
        if requiredForRule.count == 1 {
            return optionsForFirst
        }
        
        let secondRule = requiredForRule.last!
        
        var results = Set<String>()
        
        optionsForFirst.forEach { firstOption in
            existingRules[secondRule]!.forEach { secondOption in
                results.insert(firstOption + secondOption)
            }
        }
        
        return results
    }
}


extension String {
    private var ruleParts : [String] {
        self.components(separatedBy: ": ")
    }
    
    var ruleChildrenString : String {
        ruleParts.last!
    }
    
    var requiredRules : [String] {
        ruleParts.last!.components(separatedBy: " ").filter { $0 != "|" }
    }
    
    var ruleNumber : String {
        ruleParts.first!
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
