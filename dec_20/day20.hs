import           Data.Bits

expand :: a -> [a] -> [a]
expand value line = value : value : (line ++ [value, value])

indicies :: Int -> Int -> [(Int, Int)]
indicies x y = zip x' y'
  where
    f a = [a + 1, a, a - 1]
    x' = concatMap (replicate 3) . f $ x
    y' = concat . replicate 3 . f $ y

applyAlg :: [[Int]] -> [Int] -> Int -> Int -> Int
applyAlg image alg x y = alg !! idx
  where
    idx =
      foldr ((\i j -> (j `shiftL` 1) + i) . (\(a, b) -> image !! a !! b)) 0 .
      uncurry indicies $
      (x, y)

grow :: [[Int]] -> [[Int]]
grow image = expand line . map (expand 0) $ image
  where
    line = replicate ((+ 4) . length . head $ image) 0

run :: [Int] -> [[Int]] -> [[Int]]
run alg image = map (\i -> map (f' i) xs) xs
  where
    expanded = grow image
    iota xs = [1 .. length xs - 2]
    xs = iota expanded
    f' = applyAlg expanded alg

runN :: Int -> [Int] -> [[Int]] -> [[Int]]
runN 0 alg image = image
runN n alg image = runN (n - 1) alg nextImage
  where
    nextImage = run alg image

parseInput :: [String] -> ([Int], [[Int]])
parseInput [a, b] = (read a, read b)
parseInput _      = error "Invalid input"

main =
  interact
    ((++ "\n") . show . sum . map sum . uncurry (runN 2) . parseInput . lines)
