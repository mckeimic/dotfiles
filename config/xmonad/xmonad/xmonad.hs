import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Solarized

main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/hunt0r/.xmobarrc"
xmonad $ defaultConfig
    {-{ normalBorderColor = solarizedBase01-}
    { normalBorderColor = solarizedCyan
    , focusedBorderColor = solarizedBlue
    , manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock") --mod4mask is the windows key
    , ((mod1Mask .|. shiftMask, xK_g), spawn "google-chrome")
    , ((mod1Mask,  xK_p), spawn "gmrun")
    , ((0, xK_Print), spawn "gnome-screenshot")
    ]
