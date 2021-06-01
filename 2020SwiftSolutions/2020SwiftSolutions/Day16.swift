//
//  Day16.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 01/06/2021.
//

import Foundation
import PuzzleBox

class Day16 {
    let myTicket = [131,67,137,61,149,107,109,79,71,127,173,157,167,139,151,163,59,53,113,73]
    let fields = Day16TicketFieldParser().ticketFields
    let tickets = Day16OtherTicketsParser().tickets
    
    func part1() {
        print(tickets.reduce(0, { acc, next in
            acc + next.getSumOfInvalidFields(fields: fields)
        }))
    }
    
    func part2() {
        let fields = getFieldsIndices()
        
        print(fields.filter { $0.key.contains("departure") }.values.reduce(1, { acc, index in
            acc*myTicket[index]
        }))
    }
    
    func getFieldsIndices() -> [String : Int] {
        let validTickets = tickets.filter { !$0.isCompletelyInvalid(fields: fields) }
        var remainingFields = fields
        var foundColumns : [String : Int] = [:]
        
        while (!remainingFields.isEmpty) {
            for field in remainingFields {
                let possibleColumns = validTickets.columnsValidFor(field: field).filter { !foundColumns.values.contains($0) }
                if possibleColumns.count == 1 {
                    foundColumns[field.name] = possibleColumns.first!
                }
            }
            
            remainingFields = remainingFields.filter { foundColumns[$0.name] == nil }
        }
        
        return foundColumns
    }
}

extension Collection where Element == [Int] {
    func column(at i : Int) -> [Int] {
        self.map { $0[i] }
    }
    
    func columnsValidFor(field : TicketField) -> [Int] {
        (0 ..< first!.count).filter { columnIndex in
            column(at: columnIndex).allSatisfy { field.isNumberValid($0) }
        }
    }
}

extension Collection where Element == Int {
    func isCompletelyInvalid(fields : [TicketField]) -> Bool {
        self.contains(where: { number in
            !fields.contains(where: { field in
                field.isNumberValid(number)
            })
        })
    }
    
    func getSumOfInvalidFields(fields : [TicketField]) -> Int {
        self.filter { number in
            !fields.contains(where: { field in
                field.isNumberValid(number)
            })
        }.reduce(0, +)
    }
}


class Day16TicketFieldParser : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day16Fields.txt")
    }
    
    var ticketFields : [TicketField] {
        inputStringUnparsed!.components(separatedBy: .newlines).map { line in
            let parts = line.components(separatedBy: ": ")
            let name = parts.first!
            let ranges = parts.last!.components(separatedBy: " or ").map { $0.parseRangeString() }
            return TicketField(name : name, lowerRange: ranges.first!, upperRange: ranges.last!)
        }
    }
}

struct TicketField {
    let name : String
    let lowerRange : ClosedRange<Int>
    let upperRange : ClosedRange<Int>
    
    func isNumberValid(_ n : Int) -> Bool {
        lowerRange.contains(n) || upperRange.contains(n)
    }
}

class Day16OtherTicketsParser : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day16Tickets.txt")
    }
    
    var tickets : [[Int]] {
        inputStringUnparsed!.components(separatedBy: .newlines).map { line in
            line.components(separatedBy: ",").map {
                Int($0)!
            }
        }
    }
    
}

extension String {
    func parseRangeString() -> ClosedRange<Int> {
        let parts = self.components(separatedBy: "-")
        return Int(parts.first!)! ... Int(parts.last!)!
    }
}
