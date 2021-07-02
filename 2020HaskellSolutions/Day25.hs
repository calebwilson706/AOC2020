module Day25 where


divider = 20201227
cardPublicKey = 11239946
doorPublicKey = 10464955

getSubjectNumber :: Int -> Int -> Int 
getSubjectNumber loopSize inputNum = foldl step 1 [1 .. loopSize]
    where step acc _ = (acc * inputNum) `rem` divider

findLoopSizeHelper :: Int -> Int -> Int -> Int -> Int
findLoopSizeHelper search subjNumber value counter = answer
    where nextCall = findLoopSizeHelper search subjNumber ((value*subjNumber) `rem` divider) (counter + 1) 
          answer 
            | search == value = counter
            | otherwise = nextCall
     
findKeyLoopSize :: Int -> Int
findKeyLoopSize key = findLoopSizeHelper key 7 1 0            

cardLoopSize :: Int
cardLoopSize = findKeyLoopSize cardPublicKey

doorLoopSize :: Int
doorLoopSize = findKeyLoopSize doorPublicKey

part1 :: IO ()
part1 = print $ getSubjectNumber cardLoopSize doorPublicKey

main :: IO()
main = part1
