# Crypto

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()

## Description
A set of tools for working with cryptography.

## Requirements
- iOS 8.0+
- Xcode 7.3+

## Installation
### Carthage

To integrate `Crypto` into your project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Crypto`:

```
github "valery-bashkatov/Crypto"
```
And then follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to install the framework.

## Documentation
API Reference is located at [http://valery-bashkatov.github.io/Crypto](http://valery-bashkatov.github.io/Crypto).

## Usage

```swift
import Crypto

let rsaKeyPair = try! Crypto.generateKeyPair(.rsa2048)
```