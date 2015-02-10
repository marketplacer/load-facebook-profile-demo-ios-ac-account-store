//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Evgenii Neumerzhitckii on 11/08/2014.
//  Copyright (c) 2014 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit
import Accounts
import Social

let TegLoginDemo_facebookAppId_userDefaultsKey = "facebook App id"

class ViewController: UIViewController {

  let accountsStore = ACAccountStore()
  var socialAccount:ACAccount?
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var appIdTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    statusLabel.text = ""
    appIdTextField.text = appId
  }

  func getFacebookAccountInfo() {
    view.endEditing(false)
    statusLabel.text = "Loging in..."

    storeAppId_inUserDefaults()

    if let currentAppId = appId {
      getFacebookAccountInfo(currentAppId)
    } else {
      statusLabel.text = "Enter your Facebook APP Id"
    }
  }

  func getFacebookAccountInfo(forAppId: String) {
    TegLoginWithFacebook.requestAccessToFacebookAccount(forAppId) {
      accountStore in

      if let currentAccountStore = accountStore {
        if let currentAccountName = TegLoginWithFacebook.accountName(currentAccountStore) {
          self.statusLabel.text = "Logged in \(currentAccountName)"
        }
        self.getFacbookMeInfo(currentAccountStore)
      } else {
        self.statusLabel.text = "Error"
      }
    }
  }


  private func storeAppId_inUserDefaults() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(appIdTextField.text, forKey: TegLoginDemo_facebookAppId_userDefaultsKey)
    userDefaults.synchronize()
  }

  private var appId: String? {
    let userDefaults = NSUserDefaults.standardUserDefaults()

    if let currentAppId = userDefaults.valueForKey(
      TegLoginDemo_facebookAppId_userDefaultsKey) as? String {

      if currentAppId.isEmpty { return nil }
      return currentAppId
    }

    return nil
  }

  private func getFacbookMeInfo(accountStore: ACAccountStore) {
    TegLoginWithFacebook.loadProfileInfo(accountStore) { data in
      if let currentData = data {
        self.onFacebookMeLoaded(currentData)
      }
    }
  }

  private func onFacebookMeLoaded(data: NSDictionary) {
    var emailAddress = data["email"] as NSString
    var facebookId = data["id"] as NSString

    statusLabel.text = "Logged with Facebook \n \(emailAddress) \n User id: \(facebookId)"
  }

  @IBAction func loginToFacebookTapped(sender: UIButton) {
    getFacebookAccountInfo()
  }
}

