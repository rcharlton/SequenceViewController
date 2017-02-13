# SequenceViewController
Demo of a custom container view controller.

SequenceViewController (.swift) is a stand-alone class that can present a dynamic sequence of view controllers with horizontal transition animations.

Unlike say UINavigationController there is no stack or other collection of view controllers. A sequenced view controller's lifetime is nothing more than its screen-time. SequenceViewController can form the basis of a dynamic onboarding UX or other "card" style interface.


	let sequenceViewController = SequenceViewController()
	// Add sequenceViewController to your view and view controller
	// hierarchy either programmatically or using a xib or storyboard.

	// Make any view controller you like.
	let viewController = UIViewController()
	viewController.view.frame = sequenceViewController.view.bounds
	viewControllere.view.backgroundColor = UIColor.cyan

	// Present it.
    sequenceViewController.sequenceViewController(
        viewController,
        direction: .forwards,
        animated: true)
		
	