## Debugging
- useful to see where code is failing and how far it gets.
- the larger file in the debug files is usually the one you want.
- you can get into different log levels if you're getting too much information
    - loggingLevel.Fine, Finest, Info, Warn, Error
    - access log levels in the dev console
    - if you're seeing too much info, set it to error.
    - you can also add debug logs within the salesforce ui


## Exceptions
- try catch statements to keep code moving if you know something is breaking it
- Database class can determine if all of the records will pass or fail if individual cases fail

##Testing
- cant edit code in production, we need to deploy it
- SF runs tests in the context of a 'fresh' database ie: no records
- you can dd @seealldata = true
    - this is not recccomended!
    - causes longterm problems
- ATG code Library has util libraries

- we want to write assertions that allow us to check the results of our code.

- we can use test classes to make cleaner code and avoid limits
    - @testSetup
        - runs first
        - make data available
        - resets limits afterwards
    - don't worry too much about testSetup method unless you're approaching limits
    Test.startTest()
    Test.stopTest()
     - moves tests onto a different thread
     - Asycnhronous code is moved inot the synchrous enviroenment.
     - gives you an additioanl 100 SOQL queries in between the methods
     - YOU NEED THESE METHODS FOR ASYNCHRONOUS CODE


- pricebooks do exist in the system and need to be grabbed.