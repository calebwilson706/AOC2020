module Day6 where

import Helpers

day6FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day6Input.txt"

myGroups :: String -> [String]
myGroups = splitBy "\n\n"

groupLines :: String -> [[String]]
groupLines = map lines . myGroups

numberAnswerdByAll :: [Char] -> Int
numberAnswerdByAll group = count (\(_,num) -> num == people) frequencies
    where frequencies = getFrequencyMapOfElements group
          people = 1 + count (=='\n') group

part1 :: String -> IO ()
part1 input = print $ sum $ map (length . getFrequencyMapOfElements . filter (/='\n')) (myGroups input)

part2 :: String -> IO ()
part2 input = print $ sum $ map numberAnswerdByAll $ myGroups input

main ::IO()
main = do inputText <- readFile day6FilePath
          part2 inputText