# Getting user Facebook profile information using ACAccountStore on iOS/Swift

This is a collection of functions for getting user's Facebook ID, email address and other profile information.
This information is loaded from the current Facebook account stored on the device.
This code uses `ACAccountStore` which is built-in into iOS rather than the Facebook SDK.

## Setup

1. Copy `TegLoginWithFacebook.swift` file into your project.
1. Go to facebook developers web site and register a new app. You will need the `App ID`.

## Usage

### Check if we can login to Facebook

```
TegLoginWithFacebook.canLogin("Your Facebook App ID") {
  weCanLogin in

  // All good when weCanLogin == true
}
```

The functino is used to check if we can get current user account information. If user account exists it will display a dialog asking for permission to access user's Facebook profile information.

<img src="ios_swift_facebook_login_demo_permissions_alert.png" width="278" alt="Facebook permissions dialog login demo on iOS">

### Request access to Facebook account

```
TegLoginWithFacebook.requestAccessToFacebookAccount("Your Facebook App ID") {
  accountStore in

  // `accountStore` can be nil on error.
}
```

Get `ACAccountStore` object that will be used in other functions to get user's Facebook profile information.
The `accountStore` will be nil if error occured.

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

Returns an `NSDictionary` that **can** have the following keys:

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

Gets Facebook access token. This function can be useful for facebook login in the app. The token is used by your server to verify the facebook user ID. The server will send the following request: `https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN`. This request will return the user id which you will compare with User id returned by `TegLoginWithFacebook.loadProfileInfo` function.

`accountStore` argument is obtained by calling `TegLoginWithFacebook.requestAccessToFacebookAccount`.

Function can return `nil` on error.

## Home repository


