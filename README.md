# Browser Method Middleware Provider for Vapor

![Swift](http://img.shields.io/badge/swift-3.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-2.0-brightgreen.svg)
[![CircleCI](https://circleci.com/gh/bygri/browser-method-middleware-provider.svg?style=shield)](https://circleci.com/gh/bygri/browser-method-middleware-provider)

Vapor's `ResourceRepresentable` likes to use
[a wide range of HTTP verbs](https://docs.vapor.codes/2.0/vapor/controllers/#actions),
but browsers like to use only `GET` and `POST`.

A [common solution](http://guides.rubyonrails.org/form_helpers.html) is to allow
a `POST` request containing a special key `_method` which tells the server what
HTTP method was actually intended.

This provider allows Vapor to do the same thing.

## Setup
Add the dependency to Package.swift:

```swift
.Package(url: "https://github.com/bygri/browser-method-middleware-provider.git", majorVersion: 1)
```

Register the provider with the configuration system:

```swift
import BrowserMethodMiddlewareProvider

extension Config {
    /// Configure providers
    private func setupProviders() throws {
        ...
        try addProvider(BrowserMethodMiddlewareProvider.Provider.self)
    }
}
```

And finally, add the `browser-method` middleware key to the Droplet by editing
`droplet.json`:

```js
{
    "middleware": [
        ...
        "browser-method"
    ],
}
```

## Usage

TL;DR:

```html
<input type='hidden' name='_method' value='patch'>
```

Longer example:

`ResourceRepresentable` only routes to `update()` if the request uses the
`PATCH` method, but most browsers will only send a form using `POST`. So, if you
are creating a widget edit form, you can make Vapor think you sent a `PATCH`
request by adding a hidden input named `_method` with value `patch` to your
form.

```html
<form method='post' action='/widget/#(widget.id)'>
    <input type='hidden' name='_method' value='patch'>
    <p>
        Name
        <input type='text' name='name' value='#(widget.name)'>
    </p>
    <p>
        Description
        <input type='text' name='description' value='#(widget.description)'>
    </p>
    <button type='submit'>Update</button>
</form>
```

## Package name

Can you think of a better one?
