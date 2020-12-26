# Changelog

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

- Glitch when fast popping multiple view controllers ([3](https://github.com/Enricoza/EZCustomNavigation/issues/3)).