## Personal Dictionary (iOS app) 

__App where a user creates the personal dictionary of foreign words.__

The user enters a word, the word is added to the personal dictionary. The app loads a translation for the word from an online translation API.

The user can see all words of the personal dictionary on the main screen of the app.

The app is able to work with at least 3 languages and to change a direction of a translation.

The user can find a word in the dictionary by searching by a word or its translation.

The user can add a word to favourites. The app has a screen of favourite words. The user can remove a word from favourites.

A favourite word is marked with a star.

Local push notifications with a suggestion to add a new word to the personal dictionary.

A screen with a dictionary entry for a word.

### The app stack.

UI: UIKit, code-based layout.

Architecture: MVVM, Unidirectional Data Flow, Clean Architecture.

Networking: `URLSession`.

Data storage: Realm.

The code should be covered by unit tests. You can use integration, UI, snapshot testing.

---

## Notes on the solution.

To fetch translations from online API you have to get a key for [PONS Online Dictionary API](https://en.pons.com/p/online-dictionary/developers/api) and set it in a `ponsApiSecret` property of the app configuration object.

The app is implemented as a 'Super-app' where a user can work with _Personal Dictionary_ and _Todolist_. The code is modularized to 4 parts. The modules are SPM packages.

```
                  ------------
           ----->| CoreModule |<---
          |       ------------     |
          |             ^          |
          |             |          |
          |     ---------------    |
          |  ->| SharedFeature |<- |
          | |   ---------------   ||
          | |                     ||
 --------------------         ----------
| PersonalDictionary |-----> | TodoList |
 --------------------         ----------

```

The Personal Dictionary has 5 screens:

![alt text](appscreens.png "")

* Main screen where a user can see all words of the dictionary.
* A screen where user can add a new word.
* The search screen where a user can find words from the dictionary.
* A screen with a list of favourite words.
* A dictionary entry screen.

__The app architecture__. It can be represented as a tree of feature nodes:

![alt text](pers-dict-arch.png "")

Grey nodes represent viewless features, green is for a feature that implements a screen of the app, blue color is for a feature having a view that represents a part of a screen.

`B` - builder, `G` - graph, `R` - router, `V` - view, `VC` - ViewController, `MVVM` - UI pattern, `UDF` - Unidirectional Data Flow, `D` - domain.  

The code of the app screens are placed in the `UIFeature/FullScreen` folder of the `PersonalDictionary` module. 

`Builder` instantiates the app features.

`Repository` is local storage of the words of the personal dictionary. The implementation uses the Realm database.

`DictionaryService` fetches data from network API. The app addresses to the PONS Online Dictionary API.

`CoreModule` - core types for the app.

The app is localized to 2 languages (_English_ and _Russian_).

Dependency management: SPM.

# General Guide to Architecture and App Feature Development.

This project is developed using [the BFG Architecture](https://github.com/maksimn/bfg-architecture) approach.
