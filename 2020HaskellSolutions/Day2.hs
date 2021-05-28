module Day2 where

import Helpers
day2FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day2Input.txt"

xor :: Eq a => a -> a -> Bool
xor a b = a /= b

parseLine :: [Char] -> (Int, Int, Char, String)
parseLine line = (num1,num2,char,password)
    where altLine = replaceOccurences '-' ' ' line
          parts = words altLine
          num1 = read (head parts) ::Int
          num2 = read (parts!!1) ::Int
          char = head (parts!!2)
          password = last parts

passwordTuples :: String -> [(Int, Int, Char, String)]
passwordTuples input = map parseLine $ lines input

part1predicate :: (Int, Int, Char, String) -> Bool
part1predicate (x1,x2,c,line) = x1 <= result && x2 >= result
    where result = count (==c) line

part2predicate :: (Int, Int, Char, String) -> Bool
part2predicate (x1,x2,c,line) = (line!!(x1 - 1) == c) `xor` (line!!(x2 - 1) == c)

solution :: ((Int, Int, Char, String) -> Bool) -> String -> IO ()
solution predicate input = print $ count predicate $ passwordTuples input

part1 :: String -> IO ()
part1 = solution part1predicate

part2 :: String -> IO ()
part2 = solution part2predicate

main :: IO()
main = do inputText <- readFile day2FilePath
          part2 inputText