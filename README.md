# SamBl (pronounced as Sam-bal, also short for “SameBlock”)
SamBl is a neighbourhood level food delivery service that allows its user to offer to
deliver food to neighbours in return for a small charge. Put simply, it is a peer-to-peer food delivery app. The goal of our service / app is to be a cheaper and fairer alternative to traditional online food delivery services. Our main focus is on small orders from food places near the user. Moreover, we aim to incorporate fairness into our service / app with features such as having the delivery charge scale with the difficulty of the order. This would reduce the problem where a user who orders only one or two dish must pay a disproportionately high delivery charge. Furthermore, by having members of the same community deliver to one another, this app promotes interactions in the community which leads to a happier community in general.

**Core features of Sambl:** 
* Authentication system using Firebase authentication
* Order placement system using Cloud Firestore + Cloud functions
* Open orders creation system using Cloud Firestore + Cloud functions
* Retrieval system for lists of Hawker centres and open orders using Cloud
  Firestore
* Centralised payment system through PayPal
* Order status flags (pending, approved, purchased, delivered)
* Order status flag update system
* Google maps integration (to help with things such as selecting hawker centres,
  ranking open order, and specifying the pick-up point)
* Find user’s current location in one click.
* Automatic hawker centre selection by location
* Instant messaging between orderer and deliverer
