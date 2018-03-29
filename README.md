# Splash Transition

![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![Language](https://img.shields.io/badge/language-swift-orange.svg)
[![Contact](https://img.shields.io/badge/contact-@pdamonkey-blue.svg)](https://twitter.com/pdamonkey)

This repo contains an example of some launch splash transitions.

## Transitions

### BasicSplitTransition

This transition splits the splash screen at the divider position to show the main screen underneath.

### FinalSplitTransition

This transition moves the divider to the centre of the screen while also hiding the logo image into the divider.  Then it splits the splash screen at the new divider position to show the main screen underneath.

## Storyboard setup explained

Auto Layout is used on both the Launch Storyboard as well as the Splash View Controller Scene on the Main Storyboard.  By matching the autolayout and views on both storyboards there is a smoth transition from launch screen to splash view controller.

The logo consists of two images with the container view centered on the screen.  The divider layer is then positioned depending on the left logo image, in this way the logo images can easily be changed and the layout and transitions will still work as expecteed.

The divider constraint is used within the transitions and the movement values are calculated from its position.

The background images are both 1366x1366 in size.  This allows full control of how both sides look and in this case allows for the very subtle effect where the diagnal line doesn't quite match in the centre.

## Launch screen

![Screenshot of launch screen prior to animation](screenshots/launch-screen.png?raw=true "Launch Screen")
