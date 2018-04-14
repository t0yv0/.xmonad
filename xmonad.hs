import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run

import qualified Data.Map as M

main :: IO ()
main = do
    _ <- runProcessWithInput "/usr/bin/setxkbmap" ["-option", "ctrl:nocaps"] ""
    xmonad $ defaultConfig { terminal        = "myterm"
                           , startupHook     = myStartupHook
                           , modMask         = mod4Mask
                           , keys            = myKeys
                           , handleEventHook = ewmhDesktopsEventHook <+> docksEventHook
                           , manageHook      = manageDocks <+> manageHook defaultConfig
                           , layoutHook      = avoidStruts $ layoutHook defaultConfig
                           }

myKeys conf@(XConfig {XMonad.modMask = modMask}) = overrides `mappend` keys defaultConfig conf
  where
    overrides = M.fromList $
        [ ((modMask, xK_b), sendMessage ToggleStruts)
        , ((modMask .|. shiftMask, xK_q), spawn "xfce4-session-logout")
        ]

myStartupHook = do
    ewmhDesktopsStartup
    _ <- runProcessWithInput "/usr/bin/xfce4-panel" ["--restart"] ""
    setWMName "LG3D" -- IntelliJ scaling
