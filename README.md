# Login with Facebook and load user profile using ACAccountStore on iOS/Swift

Collection of functions for getting user's Facebook ID, email address and other profile information.
This information is loaded from the current Facebook account stored on the device.
The code uses `ACAccountStore` which is built-in into iOS rather than the Facebook SDK.

These functions can be used to login your users with Facebook in the app.

## Setup

1. Copy `TegLoginWithFacebook.swift` file into your project.
1. Go to facebook developers web site and register a new app. You will need the `App ID`.

## Usage

### Check access to user's Facebook profile

```
TegLoginWithFacebook.checkAccess("Your Facebook App ID") {
  accessGranted in

  // All good when accessGranted == true
}
```

Check if we can get current user account information. If Facebook user account exists it will display a dialog asking for permission to access user's Facebook profile information.

<img src="https://raw.githubusercontent.com/exchangegroup/load-facebook-profile-demo-ios-ac-account-store/master/graphics/ios_swift_facebook_login_demo_permissions_alert.png" width="278" alt="Facebook permissions dialog login demo on iOS">

### Request access to Facebook account

```
TegLoginWithFacebook.requestAccessToFacebookAccount("Your Facebook App ID") {
  accountStore in

  // `accountStore` can be nil on error.
}
```

Get `ACAccountStore` object that will be used in other functions to get user's Facebook profile information.
The `accountStore` will be nil if error occurred.

### Get profile information

```
TegLoginWithFacebook.loadProfileInfo(accountStore) {
  data in

  if let currentData = data {
    let userId = currentData["id"]
    let email = currentData["email"]
  }
}
```

Loads user's profile data. `accountStore` argument is obtained by calling `TegLoginWithFacebook.requestAccessToFacebookAccount`.

Returns an `NSDictionary` that **may** have the following keys:

* id
* timezone
* link
* locale
* birthday
* email
* last_name
* verified
* gender
* name
* first_name
* updated_time

Please note that there is no guarantee it will return the information. There can be an error or user
can deny sharing certain profile fields.

Callback function passes `nil` argument on error.

### Get access token

```
TegLoginWithFacebook.accessToken(accountStore)
```

Returns Facebook access token. This function can be useful for Facebook login in the app. The token is used by your server to verify the Facebook user ID by sending the following request: `https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN`. This request will return the user id which can be compared with User id returned by `TegLoginWithFacebook.loadProfileInfo` function.

`accountStore` argument is obtained by calling `TegLoginWithFacebook.requestAccessToFacebookAccount`.

Function can return `nil` on error.

## Demo app

<img src="https://raw.githubusercontent.com/exchangegroup/load-facebook-profile-demo-ios-ac-account-store/master/graphics/facebook_login_demo_app_ios_swift.png" width="320" alt="Login with Facebook demo app for iOS/Swift">

## Home repository

https://github.com/exchangegroup/load-facebook-profile-demo-ios-ac-account-store
