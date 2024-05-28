## Logging.

What kind of information should be logged?

* User actions (taps, gestures, text editing etc.)
* A start and a result (a success or an error) of a sync or async IO/Network/Effect/API operation.
* Sending data to a stateful model stream and receiving them from it.
* State changes in a business logic layer.
* A show/dismiss of a screen, navigation, an installation and a dismissing of a feature.

A code of logging should not be mixed with a code of the business logic. Logging should be implemented with usage of the _Decorator_ pattern.
