# Configly iOS library
> The iOS library for [Configly](https://www.config.ly): the modern config/static data key/value store that's updatable through a fancy web UI.

![GitHub](https://img.shields.io/github/license/configly/js)

Table of Contents
=================

- [What is Configly?](#what-is-configly-)
  * [Core Features](#core-features)
  * [Concepts / Data Model](#concepts---data-model)
    + [Types](#types)
- [Getting Started](#getting-started)
  * [1. Get your API Key](#1-get-your-api-key)
  * [2. Create your first Config](#2-create-your-first-config)
  * [3. Install the client library (via Swift Package Manager)](#3-install-the-client-library--via-swift-package-manager-)
  * [4. Fetch the Config](#4-fetch-the-config)
- [Usage](#usage)
  * [Fetching String's, Booleans and Numbers](#fetching-string-s--booleans-and-numbers)
  * [Fetching JSON](#fetching-json)
    + [Fetching complex JSON Blobs](#fetching-complex-json-blobs)


## What is Configly?

[Configly](https://www.config.ly) is the place software developers put their static / config data&mdash;like copy, styling, and minor configuration values.
They can then update that data directly from [https://www.config.ly/config](https://www.config.ly/config)
without having to wait for a deploy process app store review. Their app or webapp receives the data near instantly.
Non-technical folks themselves can publish changes freeing developers to focus on hard software problems and not copy tweaks.

On the backend, [Configly](https://www.config.ly) provides a read-optimized static-data key/value store built
with the aim of being low-latency, and high-availability. The client libraries are made to be dead-simple, lean, and efficient
(via enhancements like caching). There is a fancy [web UI called the Configulator](https://config.ly/config)
for setting and updating the configs as well as seeing things like change history.

There are a host of other benefits to using Configly (such as ensuring you do not have [data duplicated across clients](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), reducing load on your primary DB, and providing better tolerance for traffic spikes),
read more about the benefits at [Configly](https://www.config.ly).

### Core Features

- API to fetch Strings, JSON Blobs (arrays and objects), Booleans, and Numbers from the Configly backend
- [Web interface](https://www.config.ly/config) for modifying these values without having to deploy code (we call our beloved web interface _the Configulator_).
- High availability, high-throughput, low-latency backend.
- Smart caching on the client libraries to minimize server requests.
- Client libraries available in an expanding amount of languages.

### Concepts / Data Model

- A Configly account contains a set of *Configs*.
- A *Config* is a key-value pair along with associated metadata (like TTL).
- The keys are strings.
- The values are one of the following types:

#### Types

| Type    |  notes   | Example(s)|
|---------|----------|----------|
| string  |          | "I <3 Configly!" |
| number  | Can be integers or decimal; _be aware some clients require you to specify which when fetching_  | 31337, 1.618 |
| boolean | only true or false | true, false |
| jsonBlob | A [JSON5](https://json5.org/) (more relaxed JSON) array or object. | `["one", 5, true]``  * [License](#license)"text": "Buy now!", color: "#0F0"}`|

##### More jsonBlob examples
You can make arbitrarily complex JSON structures -- _as long_ as the top level is
an object or array. This is incredibly powerful as you can send a host of data
with a single _config_:


A more complex array for a store inventory. Note that because we're using JSON5, quotes
are optional for single words.
```js
[
  "Simple T-shirt",
  "Basic hoodie",
  {
    item: "Complex T-shirt",
    sizes: ['S', 'M', 'L'],
    price_us_cents: [1099, 1499, 1599],
  }
]
```
And a more complex object showing how you can internationalize and set style:
```js
{
  "welcome_message": {
    copy: {
      'en': 'Welcome!',
      'es': "¡Bienvenidos!",
    }, style: {
      color: '#0F0',
      fontWeight: '700',
    }
  },
  "buy_button" : {
    copy: {
      'en': 'Buy',
      'es': "Comprar",
    }, style: {
      backgroundColor: "#F00",
      border: "border-radius 10px",
    }
  }
}
```
## Getting Started

In four easy steps!

### 1. Get your API Key
You'll need a [Configly](https://www.config.ly) account. Registration is lightning quick&mdash;you can register via
visiting https://www.config.ly/signup .

After signing up, you can grab your API Key from https://www.config.ly/config .
You'll need your API Key below to integrate the library into your app.

### 2. Create your first Config
From https://www.config.ly/config, create a new Config via the "Add" button:
![image](https://user-images.githubusercontent.com/184923/98487495-3b42ca80-21f1-11eb-9bfc-bfd429733362.png)

Consider creating a simple JSON Object or Array called `greetings` and  give it the value of:
`[hello', 'hola', '你好', 'नमस्ते']`
https://www.config.ly/config should look like this:

![image](https://user-images.githubusercontent.com/184923/98494454-09d6f880-220b-11eb-9ef7-36709ddc129f.png)

Be sure to save via clicking 'Send to Clients'. Now, we'll write client code to fetch this key.

### 3. Install the client library (via Swift Package Manager)

In your iOS project, go to `File -> Swift Packages -> Add Package Dependency...`, enter the
Github repo URL: `https://github.com/configly/ios`.

### 4. Fetch the Config
Add the following code in the execution path. For simplicity, in an iOS app, you could add it to
`AppDelegate : func application(UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Bool`.

Place this import at the top of the file in which you'll call the Configly library.
```swift
import configly
```


And place this code snippet in the execution path:
> **Be sure to substitute your own API KEY**
> If you created a Config named something other than 'greetings', be sure to change it below.
```swift
let client = CNGClient.setup(withApiKey: "YOUR_API_KEY")
client.stringArray(forKey: "greetings") { (error, value) -> () in
  guard let value = value else {
    print("Config.ly couldn't find that key. Did you create the 'greetings' Config as Step 2 of 'Getting Started' demonstrates?")
    return
  } 
  print("Yay! A successful Config.ly integration!\n greetings -> \(value)")
};
```

Execute the project and you should see the payload printed! Try changing
some values on https://www.config.ly/config to confirm that
the client is getting the updates.

Congratulations you have Configly working end-to-end! Now, feel free to use Configly with all your projects!

## Usage
> The golden rule of Configly library use is: **do NOT** assign the result of a et()to a long-lived variable; in order to check for new values from the server, you must call et()

The package needs to be configured with your account's API key, which is available in the
[Configly Configulator](https://config.ly/config)

Assume in Configly you have two keys with English and Spanish copy:
```
en_copy:
[
  'Configly allows you to put all your constants in the cloud',
  'This means you can make changes to your data super fast without waiting on a deploy',
  'Also, business people love the cloud, so win-win'
]

sp_copy:
[
  'Nunca va a molestarme un hombre de negocio de cambiar el texto',
  '¡Tengo muchisímas ganas de usar Configly!',
  'No voy a poner datos constantes en mi codigo ya que conozco este sitio',
]
```

Now, based on the language of the user, you can fetch the proper translation:
```
    func setCopy(callback: (String, String, String) -> ()) {
        CNGClient.setup(withApiKey: "Dem0apiKEY")
        let copyKey = userSpeaksSpanish() ? "es_copy" : "en_copy"
        CNGClient.shared().stringArray(forKey: copyKey) { (error, value) in
            if (error != nil) {
                print("Failed with error \(error!.status): \(error!.message)")
                return
            }
            guard let copy = value else {
                print("Could not find this key. Are you using the right API Key?")
                return
            }

            // In the real world, we'd likely pass these variables for rendering.

            // callback(copy[0], copy[1], copy[2])
            // But, to demonstrate the idea, let's simply print them
            for el in copy {
                print(el)
            }
        }
    }

    func userSpeaksSpanish() -> Bool {
        if let el =  [true, false].randomElement() {
            return el
        }
        return false
     }
```

### Fetching String's, Booleans and Numbers
The API has methods that work identically for these types:
```
public func string(forKey: String, callback: (CNGError?, String?))
```

```
public func bool(forKey: String, callback: (CNGError?, Bool?))
```

```
public func double(forKey: String, callback: (CNGError?, Double?))
```

```
public func integer(forKey: String, callback: (CNGError?, Int?))
```

### Fetching JSON
The library provides native methods for JSON string arrays (`[String]`):

```
public func stringArray(forKey: String, callback: (CNGError?, Int?))
```

and JSON String Dictionaries (`[String:String]`)

```
public func stringDictionary(forKey: String,callback: (CNGError?, Int?))
```

For these methods, all keys / values _must_ be strings or else the JSON will fail to parse!


For more complex, you need to define your own `Decodable`, as described next.

#### Fetching complex JSON Blobs
The Configly client allows you to send arbitrarily complex JSON via
[Swift's `Decodable` interface](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

Let's demonstrate through an example.

Assume we have the following `JSON` saved in [https://www.config.ly/config]:
```
store_catalog:
{
  has_sale: false,
  discount: 0.8,
  items: [ 'T Shirt', 'Hoodie', 'Ferrari', ],
  prices: [ 100, 250, 200000, ],
}
```
Define your own `Decodable`
```swift
struct StoreLandingPage: Decodable {
    var has_sale: Bool
    var discount: Double
    var items: [String]
    var prices: [Double]
}
```

Then, fetch the data:
```
let client = CNGClient.setup(withApiKey: "Dem0apiKEY")
client.object(forKey: "store_catalog") { (error, value: StoreLandingPage?) -> () in
    if (error != nil) {
        print("Failed with error \(error!.status): \(error!.message)")
        return
    }
    guard let payload = value else {
        print("Could not find this key. Are you using the right API Key?")
        return
    }

    var prices: [Double] = [];
    if (payload.has_sale) {
        for price in payload.prices {
            prices.append( Double(price) * value!.discount )
        }
    } else {
        prices = payload.prices
    }

    // Normally, you'd render these values to your app. But since this is an example, we'll just
    // print them and leave that part to you!
    if (payload.has_sale) {
        print("There is a sale!");
    }
    for (index, item) in payload.items.enumerated() {
        let amount = String(format: "$%.02f", prices[index])
        print("\(item) costs \(amount)")
    }
};
