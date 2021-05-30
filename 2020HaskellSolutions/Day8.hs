module Day8 where

import qualified Data.IntSet as DS

import Helpers
day8FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day8Input.txt"

emptySet :: DS.IntSet
emptySet = DS.fromList []

parseInput :: [Char] -> [String]
parseInput = lines . filter (/='+')

parseInstruction :: String -> (String, Int)
parseInstruction line = (head parts, read $ last parts)
    where parts = words line
    

updateIndexAndAccumulator :: String -> Int -> Int -> Int -> (Int, Int)
updateIndexAndAccumulator instruction alter index accumulator = (newIndex,newAccumulator)
    where (operatorToMutate,operand) = parseInstruction instruction
          operator
            | alter /= index = operatorToMutate
            | operatorToMutate == "jmp" = "nop"
            | operatorToMutate == "nop" = "jmp"
          (newIndex, newAccumulator)
            | operator == "acc" = (index + 1, accumulator + operand)
            | operator == "jmp" = (index + operand,accumulator)
            | otherwise = (index + 1,accumulator)


getAccumulatorAndEndSatus :: [String] -> Int -> (Int,Int,DS.IntSet) -> (Int,Bool)
getAccumulatorAndEndSatus instructions alter (accumulator,index,visited) = result
    where updatedVisited = index `DS.insert` visited
          instruction = instructions!!index
          (newIndex,newAccumulator) = updateIndexAndAccumulator instruction alter index accumulator
          result 
            | index < 0 || index >= length instructions = (accumulator,True)
            | index `DS.member` visited = (accumulator,False)
            | otherwise = getAccumulatorAndEndSatus instructions alter (newAccumulator,newIndex,updatedVisited)


part1 :: [Char] -> IO()
part1 input = print $ fst $ getAccumulatorAndEndSatus (parseInput input) (-1) (0,0,emptySet)

findTotalAfterSucccess :: [String] -> Int -> Int
findTotalAfterSucccess instructions index = answer
    where (operator,operand) = parseInstruction $ instructions!!index
          nextCall = findTotalAfterSucccess instructions (index + 1)
          (endValue,endStatus) = getAccumulatorAndEndSatus instructions index (0,0,emptySet)
          answer 
            | operator == "acc" || operand == 0 || not endStatus = nextCall
            | otherwise = endValue

part2 :: [Char] -> IO ()
part2 input = print $ findTotalAfterSucccess (parseInput input) 0

main ::IO()
main = do inputText <- readFile day8FilePath
          part2 inputText