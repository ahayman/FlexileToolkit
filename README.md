##Flexle Toolkit

The Flexile toolkit is a library of classes, extensions, functions and defines I commonly use in development. I will try to hit the highlights below, but for complete information I recommend you read the header files (which are admittedly incomplete at the moment... it's my next todo). 

I've tried to reduce the dependencies among the classes as much as possible. You can import `FlxToolkit.h` to import everything. I've also split the Toolkit into: Classes, Defines, Functions (also macros) and Extensions. Some of the classes, though, may import one of the other sections in their implementation file if I'm using that functionality.  

###Extensions
In most cases the categories simply extend functionality. However, in a few cases functionality is altered. Most notably, the NSMutableArray and NSMutableDictionary classes have a category set on their subscripting methods. I originally did this in that weird transitionary state where subscripting was available, but the foundation classes weren't yet using it. It alters the behavior slightly (and in my opinion for the better):

* You can remove a NSMutableDictionary item using: `dictionary[@"key"] = nil;`. Normally, this would result in a compiler warning, and ultimately runtime crash.
* You can remove an array item using the same method: `array[1] = nil;`.
* Array subscripts will not product an "out of bounds" exception. If your index is beyond the bounds, it will be set to the last index. So, for example, you can alway pull the last item from an array using: `array[NSUInteger_Max];`... not that you couldn't really do this using the `lastObject`, but it's there.

The subscripting changes can cause some problems with the compiler warnings. Specifically, the compiler will complain if you try to set `nil` to a subscript.  You will probably want to disable that warning if you want use this fucntionality.

###Classes
I've have a few classes I use frequently. Some of them are particularly useful:

* *FlxLinkedList*: This is mostly a standard linked list. It is not bi-directional, but it does keep track of both the head and the tail, so you can choose to add to the list rather than just push to it. Of particular note is there is a separate iterator class that allows mutation within a fast-enumeration for loop. The for loop must be constructed *on* the iterator though, and not on the list itself. However, you can easily do this by using the 'newIterator' method on the list. So, for example, you can mutate on list `linkList` using `for (object in linkList.newIterator)` but you cannot mutate on list using `for (object in linkList)`. All that being said, you only the iterator has the appropriate mutations methods. Mutation is made possible by fast enumerating one at a time, so it's not recommended that you use the iterator unless you plan on mutating the list. Otherwise, you'll loose speed and efficiency.
* *FlxCollection*: This class allow you to store objects using keyPaths as "dictionary keys" for later retrieval. You can use as many keys as you'd like but the keyPaths must return a valid object (or nil) for use as a key in a dictionary. In other words, the value returned by the stored object for the key must conform to `NSCopying` protocol and return appropriate hashes. The keys do not need to be unique though. FlxCollection will keep arrays of objects that have similar keys and you can request those objects using the appropriate method call. A stored object can return `nil` for a keypath. This simply means it won't be returned if requested along that keypath. The collection will observe changes to an object's keyPath values and keep track of them accordingly. This means if you change the value of a stored object's property, the collection will return the correct object later if you request the object using the new value and appropriate keypath.
* *FlxOrderedCollection*: This works almost exactly like the FlxCollection except you objects are also kept in an array for proper ordering.
* *FlxKVObserver*: This particularly useful class allows you to easily observer keypaths (KVO). It will attach itself to the observer (using associated objects) and automatically de-register itself on deallocation. No need to use the annoying `context` or worry about improper de-registering.

###Defines
I have quite a few defines, many of them simple shortcuts for common functions/methods I use. For example, instead of `CGRectGetMaxX` you can use `MaxX`. *So* much easier. Of particular note is the FlxTry macro. I use this for cases where a fatal assert is simply to much, but I still want to do more than simply `return` from the method (like, say, log the error or submit it to an analystics server). It will call `NonFailingException`, which is defined as FlxLog (a NSLog replacement) but you can define to be whatever you want. You can also choose to alert the user, which will display the error you enter as the second parameter in the macro in a popup. 
