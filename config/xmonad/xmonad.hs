import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Named
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Util.EZConfig
import XMonad.Util.Run

import Data.Char (toLower)
import Data.Monoid

dzenCommand   = "dzen2 $(~/.xmonad/dzen_flags)"
conkyCommand  = "conky -c ~/.conky_dzen | " ++ dzenCommand
{-trayerCommand = "trayer --edge bottom --height 24 --SetPartialStrut true"-}

xmonadStatus = dzenCommand ++ " -xs 1 -w 800 -ta l"
systemStatus = conkyCommand ++ " -xs 1 -x 780 -w 820 -ta r"
{-trayerStatus = trayerCommand ++ " --transparent true --alpha 32 --tint 0x002b36"-}

(/->)   :: Monoid m => Query Bool -> Query m -> Query m
p /-> f =  p >>= \b -> if b then idHook else f
infix 0 /->

main = do
    dzenXmonad <- spawnPipe xmonadStatus
    dzenSystem <- spawnPipe systemStatus
    {-trayer     <- spawnPipe trayerStatus-}
    xmonad $ withUrgencyHook NoUrgencyHook $ ewmh $ defaultConfig
             { startupHook = ewmhDesktopsStartup
             , manageHook = manageSpawn <+> manageDocks <+> myManageHook
             , layoutHook = avoidStrutsOn [U] $ smartBorders $ myLayout
             , logHook    = dynamicLogWithPP defaultPP
                            { ppCurrent = dzenColor "#b58900" "" . wrap "[" "]"
                            , ppUrgent  = dzenColor "#dc322f" "" . wrap "(" ")"
                            , ppTitle   = dzenColor "#268bd2" "" . shorten 70
                            , ppOutput  = hPutStrLn dzenXmonad
                            {-, ppLayout  = wrap "^i(.xmonad/icons/" ".xbm)" . (map toLower)-}
                            } >> fadeWindowsLogHook myFadeHook
             , handleEventHook = ewmhDesktopsEventHook <+> fadeWindowsEventHook
             , normalBorderColor  = "#586e75"
             , focusedBorderColor = "#d33682"
             , modMask            = myModMask
             , terminal           = "gnome-terminal"
             , workspaces         = myWorkspaces
             }
             `additionalKeys`
             [ ((myModMask .|. shiftMask, xK_t), sendMessage $ ToggleStrut D)
             , ((myModMask, xK_q), spawn
                     "xmonad --recompile && (killall conky; killall trayer; xmonad --restart)")
             , ((myModMask       ,  xK_g), spawn "google-chrome")
             , ((0       ,  xK_Print), spawn "xfce4-screenshooter -f")
             , ((mod1Mask,  xK_Print), spawn "xfce4-screenshooter -w")
             , ((shiftMask, xK_Print), spawn "xfce4-screenshooter -r")
             , ((myModMask .|. shiftMask, xK_l), spawn "gnome-screensaver-command -l")
             ]

myModMask = mod1Mask

myWorkspaces = ["1:main", "2:web", "3:terminal", "4:chat", "5:music", "6:VM"] ++ map show [7..8] ++ ["9"]

myManageHook = composeOne
               [ isFullscreen                 -?> doFullFloat
               , isDialog                     -?> doCenterFloat
               , className =? "Gnuplot"       -?> doCenterFloat
               , className =? "Xfce4-notifyd" -?> doIgnore
               , className =? "Xfrun4"        -?> doCenterFloat
               ]

myFadeHook = composeAll
             [ isUnfocused  --> transparency 0.125
             , isFullscreen --> opaque
             , isUnfocused  /-> opaque
             ]

tall = Tall nmaster delta ratio
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

wide = named "Wide" $ Mirror tall
tab  = named "Tabbed" $ tabbedBottom shrinkText defaultTheme
    { activeColor         = "#586e75"
    , activeBorderColor   = "#eee8d5"
    , activeTextColor     = "#eee8d5"

    , inactiveColor       = "#073642"
    , inactiveBorderColor = "#839496"
    , inactiveTextColor   = "#839496"

    , urgentColor         = "#586e75"
    , urgentBorderColor   = "#eee8d5"
    , urgentTextColor     = "#cb4b16"
    }

defaultLayout = tall ||| wide ||| tab

webLayout = tab ||| tall ||| wide

myLayout = onWorkspace "2:web" webLayout defaultLayout
