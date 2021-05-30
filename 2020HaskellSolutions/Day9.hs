module Day9 where

import qualified Data.Set as DS
import Data.List

day9FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day9Input.txt"

parse :: String -> [Int]
parse = map read . lines

subseqs :: [a] -> [[a]]
subseqs = concatMap inits . tails
 
subSequenceEqualTo :: Int -> [Int] -> [Int]
subSequenceEqualTo number list = head $ filter (\a -> number == sum a) $ subseqs list

doesSetContainPairToAdd :: Int -> Int -> DS.Set Int -> Bool
doesSetContainPairToAdd index goal set = answer
    where nextCall = doesSetContainPairToAdd (index + 1) goal set
          current = DS.elemAt index set
          difference = goal - current
          answer
            | difference `DS.member` set && current /= difference = True
            | index == DS.size set - 1 = False
            | otherwise = nextCall

checkIfNumberIsValid :: Int -> DS.Set Int -> Bool
checkIfNumberIsValid = doesSetContainPairToAdd 0

updateSet :: Int -> Int -> [Int] -> DS.Set Int -> DS.Set Int
updateSet size currentIndex numbers set = updatedSet
    where updatedSet = numbers!!(currentIndex - size) `DS.delete` (numbers!!currentIndex `DS.insert` set)

findFirstBadNumber :: Int -> Int -> [Int] -> DS.Set Int -> Int
findFirstBadNumber size index numbers preamble = result
    where currentAnswer = checkIfNumberIsValid currentNumber preamble
          currentNumber = numbers!!index
          newSet = updateSet size index numbers preamble
          result = if currentAnswer then findFirstBadNumber size (index + 1) numbers newSet else currentNumber

firstBadNumber :: [Char] -> Int
firstBadNumber input = findFirstBadNumber 25 25 numbers (DS.fromList $ map (numbers!!) [0..24])
    where numbers = parse input
  
part1 :: String ->  IO ()
part1 = print . firstBadNumber

part2 input = print (minimum sequence + maximum sequence)
    where sequence = subSequenceEqualTo (firstBadNumber input) (parse input)



main ::IO()
main = do inputText <- readFile day9FilePath
          part2 inputText
