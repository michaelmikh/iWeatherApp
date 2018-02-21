# About

iWeather application is built as a test task to attend to 4xxi company as an iOS developer.
Here are main focuses while building the app:

 - *CoreData*. Application have to store it's data persistently in order to work somehow without internet connection;
 - *Client-Server interaction*. Application gets useful data calling weather JSON API (apixu.com);
 - *iOS Guidelines*, *Auto Layout* and *basic iOS operations*.

# Dependencies
**SwiftLint** is used as code-style checker.

Application uses **CocoaPods** as a dependency manager. 
Dependencies:

 - Logs and debug prints: [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) (latest).

# Not done

 - Default (predefined) cities.

# Possible TODOs
- Refactor AddCityViewController to allow only valid city names;
- Get user's location to show relevant forecast;
- Extend application functionality;
- Refactor Database model to meet new functionality.
