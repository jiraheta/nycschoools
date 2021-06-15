//
//  SpinnerViewController.swift
//  CodCha
//
//  Created by Jportdev on 6/6/21.
//

import UIKit
/*
  this is a helper file. I use this in the past. I like it gray outs the screen
  giving the user more of an indication that something is happening in the background.
  obviously this is dev preference. If the require was to use the UIActivity indicator
  I would have gone that route.
 */
class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
