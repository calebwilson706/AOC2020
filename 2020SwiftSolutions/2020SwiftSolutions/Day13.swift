//
//  Day13.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 31/05/2021.
//

import Foundation

class Day13 {
    let inputString = "41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,557,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,17,x,x,x,x,x,23,x,x,x,x,x,x,x,419,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19"
    let knownBuses = [41,37,557,29,13,17,23,419,19]
    let myDesiredTime = 1005595
    
    
    func part1() {
        let correctTime = getTimesOfBusesJustAfterDesired().min(by: { $0.time < $1.time })!
        print((correctTime.time - myDesiredTime)*correctTime.id)
    }
    
    func part2() {
        let buses = inputString.components(separatedBy: ",")
        let firstBusPosition = buses.firstIndex(of: "37")!
        var validTimes = getTwoValidTimes(start: 0, factor: 37, increment: 41, position: firstBusPosition)

        for position in (firstBusPosition + 1) ..< buses.count {
            if buses[position] != "x" {
                validTimes = getTwoValidTimes(start: validTimes.0, factor: Int(buses[position])!, increment: validTimes.1 - validTimes.0, position: position)
            }
        }

        print(validTimes.0)
    }
    
    func getTimesOfBusesJustAfterDesired() -> [(id : Int,time : Int)] {
        knownBuses.map { (id : $0, time : $0.firstMultiple(greaterThan: myDesiredTime)) }
    }
    
    func getTwoValidTimes(start : Int, factor : Int, increment : Int, position : Int) -> (Int,Int) {
        var currentValue = start
        var returnList : [Int] = []
        while returnList.count < 2 {
            currentValue += increment
            
            if (currentValue + position) % factor == 0 {
                returnList.append(currentValue)
            }
        }
        
        return (returnList.first!,returnList.last!)
    }
}

extension Int {
    func firstMultiple(greaterThan n : Int) -> Int {
        var total = 0
        
        while total < n {
            total += self
        }
        
        return total
    }
}
