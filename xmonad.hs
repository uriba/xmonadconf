import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.Volume
import Data.Map (fromList)
import Data.Monoid (mappend)
import Graphics.X11.ExtraTypes.XF86
import System.IO

main = do
    xmproc <- spawnPipe "~/.cabal/bin/xmobar ~/.xmobarrc"

    xmonad $ defaultConfig
        { manageHook = manageDocks<+>manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50 }
	, modMask = mod4Mask
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((mod4Mask, xK_p), spawn "dmenu_run")
        , ((mod4Mask .|. shiftMask,xK_Up), spawn "~/layout_switch.sh")
        , ((0, xK_Print), spawn "scrot")
        , ((0, xF86XK_AudioLowerVolume), spawn "~/pa-vol.sh minus")
        , ((0, xF86XK_AudioRaiseVolume), spawn "~/pa-vol.sh plus")
        , ((0, xF86XK_AudioMute), spawn "~/pa-vol.sh mute")
        ]

