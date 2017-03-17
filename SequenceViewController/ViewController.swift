//
//  ViewController.swift
//  SequenceViewController
//
//  Created by Robin Charlton on 11/02/2017.
//  Copyright © 2017 Robin Charlton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let sequenceViewController = SequenceViewController()

    private var tapRecognizer: UITapGestureRecognizer! = nil

    private enum Action {
        static let tapGestureRecognized =
            #selector(ViewController.tapGestureRecognized(tapRecognizer:))
    }


    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {

        super.viewDidLoad()

        setupSequenceViewController()

        self.tapRecognizer = UITapGestureRecognizer(
            target: self, action: Action.tapGestureRecognized)

        view.addGestureRecognizer(tapRecognizer)

        let anyViewController = makeViewController()
        sequenceViewController.sequence(viewController: anyViewController)
    }

    /**
     Wire sequenceViewController into the view/ view controller hierarchies.
     */
    private func setupSequenceViewController() {

        let sequenceView = sequenceViewController.view!
        sequenceView.frame = self.view.bounds

        addChildViewController(sequenceViewController)
		sequenceViewController.didMove(toParentViewController: self)
        view.addSubview(sequenceView)
    }

    /**
     Called in response to a tap on the main view.
     */
    @objc private func tapGestureRecognized(tapRecognizer: UIGestureRecognizer) {

        if tapRecognizer.state == .recognized {

            let point = tapRecognizer.location(in: view)
            let direction: Direction = (point.x < view.frame.midX) ? .backwards : .forwards

            let anyViewController = makeViewController()
            sequenceViewController.sequence(
                viewController: anyViewController,
                direction: direction,
                animated: true)
        }
    }

    /**
     Create a vanilla view controller with a random background color.
     */
    private func makeViewController() -> UIViewController {

        let viewController = UIViewController()
        viewController.view.frame = sequenceViewController.view.bounds
        viewController.view.backgroundColor = UIColor.random()

        return viewController
    }
}

