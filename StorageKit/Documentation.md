# Storage
### UserDefaults

* DEFINITION: 
> An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
Source: https://developer.apple.com/documentation/foundation/userdefaults
* The UserDefaults class is thread-safe.
* The values are stored in a database.
* Can respond to changes via notification (didChangeNotification)
* Does not persist URL changes (out of the box).
* UserDefaults can be managed by user accounts:
> If your app supports managed environments, you can use UserDefaults to determine which preferences are managed by an administrator for the benefit of the user
Source: https://developer.apple.com/documentation/foundation/userdefaults#1664798
* The API performs value conversions.
> So for example an Int will be converted to Number automatically.
Source: http://www.thomashanning.com/userdefaults/

### NSUbiquitousKeyValueStore
Source: https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore
