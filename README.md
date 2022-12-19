Original App Design Project - README Template
===

# Price Huntr

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Price Huntr is an app designed to make finding the cheaptest products at all stores using a user updated database with prices. 

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Mobile is necessary for the app because it serves as the price scanner that the user will use at the store. Has to be easily accesible. 
- **Story:** Highlights the best financial options for grocery shopping or everyday items. No more going from store to store. 
- **Market:** Initially, the app will be marketed to people who often buy groceries ie parents, single people, and college students. Eventully, the app will be extended to incorporate more than just groceries.
- **Habit:** Users will constantly be on this app as they shop or to plan a shopping list. Furthermore, users will be rewarded after every successful scan.
- **Scope:** V1 will allow users to update a database with the name and price of items v2 will allow users to have their own unique accounts with a reward system and favorite items/items added v3 will allow users to scan products with the barcode v4 will have a map feature showing different stores where the specific item in question can be purchased

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* user can log in
* user can create an account
* user can add items manually with price and location and image
* user can search for items in database
* user can see their own profiles
* user can see other profiles


**Optional Nice-to-have Stories**

* user can scan barcode and make item automatically fill in some sections
* user can see a map with locations of items
* user can add friends
* user can earn points for scanning items
* user can compare to prices at other major stores ie walmart / target

### 2. Screen Archetypes

* Login Screen
   * user can login
* Registration Screen
   * user can create an account with password
* Timeline
    * user can see a timeline of recently added items
* Creation
    * User can create a new item with price on this page
* Search
    * User can search for items on this page / maybe even users
* Account
    * user can view their own account to see favorites and items they've added

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home feed
* Creation tab
* Account tab
* Search/map tab 
* Items to scan tab

**Flow Navigation** (Screen to Screen)

* Login Screen
   * home screen
   * create account screen
* home screen
   * account screen
   * item screen
* Account screen
    * None
* Search screen
    * Item screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]


![](https://i.imgur.com/H4IyMxy.jpg)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

#### User
| Property  | Type | Description |
| ------------- | ------------- | ------------- |
| name  | string | the user's real name  |
| objectId  | string | identifier |
| username | string  | user's username   |
| profile picture | image file  | user profile picture|
| points | int  | reward points given to users for scanning products|
| scanned items | pointer to items  | a dictionary or just a pointer to all items scanned by user|

#### Item
| Property  | Type | Description |
| ------------- | ------------- | ------------- |
| name  | string | name of item  |
| objectId  | string | identifier |
| prices | dictionary of prices  | a dictionary of prices containing price and the location where that price can be found|
| item picture | image file  | picture of the item|
| item picture | int | barcode of the item|



#### Location
| Property  | Type | Description |
| ------------- | ------------- | ------------- |
| name  | string | name of the specific location ie store|
| objectId  | string | identifier |
| items | dictionary of items  | a dictionary of items that can be found at this location|






### Models

* New User Screen
   * (create/POST) create a new user
* login screen
   * (read/GET) get user information to verify account
* home timeline screen
   * (read/GET) get item information to display on timeline
* Account screen
    * (read/GET) get user information to display
    * (read/GET) get item information that user has posted
* item description screen
    * (read/GET) get item information
    * (UPDATE) if user is author then allow edit to post
    * (DELETE) is user is author then allow for deleting
* item creation screen
    * (CREATE) an item post







### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]



