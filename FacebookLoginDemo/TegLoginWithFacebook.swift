//
//  TegLoginWithFacebook.swift
//  FacebookLoginDemo
//
//  Created by Evgenii Neumerzhitckii on 6/02/2015.
//  Copyright (c) 2015 The Exchange Group Pty Ltd. All rights reserved.
//

import Foundation
import Accounts
import Social

private let tegLoginWithFacebook_accountNameKey = "ACPropertyFullName"

class TegLoginWithFacebook {

  class func checkAccess(appId: String, onComplete: (Bool)->()) {
    requestAccessToFacebookAccount(appId) { accountStore in
      onComplete(accountStore != nil)
    }
  }

  class func requestAccessToFacebookAccount(appId: String, onComplete: (ACAccountStore?)->()) {
    let accountsStore = ACAccountStore()

    let options = [
      "ACFacebookAppIdKey" : appId,
      "ACFacebookPermissionsKey" : ["email"],
      "ACFacebookAudienceKey" : ACFacebookAudienceOnlyMe]
    
    accountsStore.requestAccessToAccountsWithType(facebookAccountType(accountsStore),
      options: options) { (granted: Bool, error: NSError!) -> Void in

      TegQ.main {
        onComplete(granted ? accountsStore : nil)
      }
    }
  }

  class func accountName(accountStore: ACAccountStore) -> String? {
    if let currentProperties = accountProperties(accountStore) {
      return currentProperties[tegLoginWithFacebook_accountNameKey] as? String
    }

    return nil
  }

  // The auth token can be used to verify User ID on server side
  // by sending this access token to facebook from server side
  // https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
  class func accessToken(accountStore: ACAccountStore) -> String? {
    if let currentSocialAccount = socialAccount(accountStore) {
      let credential = currentSocialAccount.credential as ACAccountCredential
      return credential.oauthToken
    }

    return nil
  }

  class func loadProfileInfo(accountStore: ACAccountStore, onComplete: (NSDictionary?) -> ()) {
    var meUrl = NSURL(string: "https://graph.facebook.com/me")
    
    var slRequest = SLRequest(forServiceType: SLServiceTypeFacebook,
      requestMethod: SLRequestMethod.GET,
      URL: meUrl, parameters: nil)

    slRequest.account = socialAccount(accountStore)

    let myaccount = socialAccount(accountStore)

    slRequest.performRequestWithHandler {
      (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in

      TegQ.main {
        if error != nil { onComplete(nil) }

        var serializationError: NSError?;

        let meData = NSJSONSerialization.JSONObjectWithData(
          data,
          options: NSJSONReadingOptions.MutableContainers,
          error: &serializationError) as? NSDictionary

        onComplete(meData)
      }
    }
  }

  // Private functions
  // ------------------

  private class func socialAccount(accountStore: ACAccountStore) -> ACAccount? {
    return accountStore.accountsWithAccountType(facebookAccountType(accountStore)).last as? ACAccount
  }

  private class func accountProperties(accountStore: ACAccountStore) -> NSDictionary? {
    if let currentSocialAccount = socialAccount(accountStore) {
      currentSocialAccount.valueForKey("properties") as? NSDictionary
    }

    return nil
  }

  private class func facebookAccountType(accountStore: ACAccountStore) -> ACAccountType {
    return accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
  }
}
