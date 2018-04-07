module NSeqPogo where


brute c d ls
  = id
  . takeWhile (/=d)
  . map fst
  . flip iterate ( 0, cycle ls )
  $ \(a,(x:xs)) -> (mod (a+x) c, xs)

bruteH c d ls = length $ brute c d ls
