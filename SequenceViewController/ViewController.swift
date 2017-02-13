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
        sequenceViewController.sequenceViewController(anyViewController)
    }

    /**
     Wire sequenceViewController into the view/ view controller hierarchies.
     */
    private func setupSequenceViewController() {

        addChildViewController(sequenceViewController)
		sequenceViewController.didMove(toParentViewController: self)

        let sequenceView = sequenceViewController.view!
        sequenceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sequenceView)

        sequenceView.leftAnchor.constraint(
            equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        sequenceView.rightAnchor.constraint(
            equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        sequenceView.topAnchor.constraint(
            equalTo: topLayoutGuide.bottomAnchor).isActive = true
        sequenceView.bottomAnchor.constraint(
            equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    /**
     Called in response to a tap on the main view.
     */
    @objc private func tapGestureRecognized(tapRecognizer: UIGestureRecognizer) {

        if tapRecognizer.state == .recognized {

            let point = tapRecognizer.location(in: view)
            let direction: Direction = (point.x < view.frame.midX) ? .backwards : .forwards

            let anyViewController = makeViewController()
            sequenceViewController.sequenceViewController(
                anyViewController,
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

