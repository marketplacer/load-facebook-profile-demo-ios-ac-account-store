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

let TegLoginDemo_facebookApiKey_userDefaultsKey = "facebook API key"

class ViewController: UIViewController {

  let accountsStore = ACAccountStore()
  var socialAccount:ACAccount?
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var apiKeyTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    statusLabel.text = ""
    apiKeyTextField.text = apiId
  }

  func getFacebookAccountInfo() {
    statusLabel.text = "Loging in..."

    storeApiId_inUserDefaults()

    if let currentApiId = apiId {
      getFacebookAccountInfo(currentApiId)
    } else {
      statusLabel.text = "Enter API"
    }
  }

  func getFacebookAccountInfo(forApiId: String) {
    TegLoginWithFacebook.requestAccessToFacebookAccount(forApiId) {
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


  private func storeApiId_inUserDefaults() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(apiKeyTextField.text, forKey: TegLoginDemo_facebookApiKey_userDefaultsKey)
    userDefaults.synchronize()
  }

  private var apiId: String? {
    let userDefaults = NSUserDefaults.standardUserDefaults()

    if let currentApiId = userDefaults.valueForKey(
      TegLoginDemo_facebookApiKey_userDefaultsKey) as? String {

      if currentApiId.isEmpty { return nil }
      return currentApiId
    }

    return nil
  }

  private func getFacbookMeInfo(accountStore: ACAccountStore) {

    TegLoginWithFacebook.loadFacebookMeInfo(accountStore) { data in
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

