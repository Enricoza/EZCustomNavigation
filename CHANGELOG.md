# Changelog

## v1.1.2
A patch that includes some fixes and improvements to the default `EZPushPopAnimator` to make it more similar to the default Navigation Controller animator.

### Changed

- `EZPushPopAnimator` default duration is increased from `0.2` to `0.33`.
- `EZPushPopAnimator` uses `animateKeyFrames` to allow usage of `calculationModeCubic` in non-interactive transitions as it's more similar to the default NavigationController animation.
- `EZPushPopAnimator` now interposes a dimming view between the animating view controllers to imitate the default NavigationController animation ([#9](https://github.com/Enricoza/EZCustomNavigation/issues/9)).
- On the completion of the interactive animation the completion curve is set to `easeInOut` instead of linear and it's removed the completionSpeed (was `0.5`).

### Fixed

- A glitch that made translucent tabBar cut the pushed view controller during animation in case of `hidesBottomBarWhenPushed = true` ([#4](https://github.com/Enricoza/EZCustomNavigation/issues/4)).

## v1.1.1
A patch that includes some fixes and improvements to the `pan-to-pop` gesture interoperability with other gestures.

### Changed

- `pan-to-pop` gesture now requires `maximumNumberOfTouches` to be 1.
- `pan-to-pop` gesture won't start if the direction of the pan is wrong.

### Fixed

- A bug that made really hard to use the delete gesture of table view cells ([#5](https://github.com/Enricoza/EZCustomNavigation/issues/5)).

### Known Issues

- Currently is not possible to activate leadingSwipeActions on UITableViews ([#6](https://github.com/Enricoza/EZCustomNavigation/issues/6))

## v1.1.0
A release that includes the first implementation of the `Unpop` behavior *(disabled by default)* and some minor fixes.

### Added

- `UnPop` behavior.
- `EZNavigationConfiguration` with the `EZUnpopConfiguration` to enable and configure the unpop behavior.
- `onShouldPopViewController` and `onShouldUnPopViewController` methods on UINavigationController extension that can be overridden to potentially exclude `pop` or `unpop` in some cases.
- `EZAnimating` protocol, needed to inform if an animator is currently animating.

### Changed

- `presentingAnimator` and `dismissingAnimator` parameters of the `EZTransitionCoordinator` needs to be conforming to `EZAnimating` protocol too.


### Fixed

- A glitch happening when fast popping multiple view controllers ([3](https://github.com/Enricoza/EZCustomNavigation/issues/3)).
- `onShouldPopViewController` default implementation returning true even if the number of view controllers in the navigation stack was less than 2.

### Deprecated

- `addCustomTransitioning(_:onShouldPopViewController)` in favor of the one without the `onShouldPopViewController` callback. This method has been moved to the NavigationController extension and can be overrided from there.

## v1.0.0
Initial release with the `Pan-To-Pop` behavior.

### Known Issues

- Glitch when fast popping multiple view controllers ([#3](https://github.com/Enricoza/EZCustomNavigation/issues/3)).