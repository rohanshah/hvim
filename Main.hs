import Graphics.Vty.Widgets.All
import Graphics.Vty.LLInput
import qualified Data.Text as T
import System.IO
import System.Exit
import System.Environment
import System.Directory

main :: IO ()
main = do
  filename      <- do arguements <- getArgs
                      case arguements of
                        []     -> error "E32: No file name"
                        (x:xs) -> return x
  fileexists    <- doesFileExist filename
  contents      <- if fileexists
                   then readFile filename
                   else return ""
  editor        <- multiLineEditWidget
  focusgroup    <- newFocusGroup
  collection    <- newCollection
  _             <- setEditText editor (T.pack contents)
  _             <- addToFocusGroup focusgroup editor
  _             <- addToCollection collection editor focusgroup
  _             <- editor `onKeyPressed` \this key _ ->
                     if key == KEsc
                     then do input <- getEditText this
                             _     <- writeFile filename (T.unpack input)
                             exitSuccess
                     else return False
  runUi collection defaultContext
