# react-native-signature-capture

<img src="http://i.giphy.com/3oEduIyWb48Ws3bSuc.gif" />

## What's new in this fork?

Basically, I needed to customize the UI and didn't want to customize the UI that was already
in the native module. This strips out all the UI elements and just leaves the drawing pad.

Instead, we've added methods that trigger, clearing and saving. This frees us up to build the UI
on the JS side.

React Native library for capturing signature

User would sign on the app and when you press the save button it returns the base64 encoded png

## Usage

First you need to install react-native-signature-capture:

```javascript
npm install --save git+https://git@github.com/brancusi/react-native-signature-capture.git
```

In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name] Go to node_modules ➜ react-native-signature-capture and add the .xcodeproj file

In XCode, in the project navigator, select your project. Add the lib*.a from the signature-capture project to your project's Build Phases ➜ Link Binary With Libraries Click .xcodeproj file you added before in the project navigator and go the Build Settings tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for Header Search Paths and make sure it contains both $(SRCROOT)/../react-native/React and $(SRCROOT)/../../React - mark both as recursive.

Run your project (Cmd+R)

## Examples

```javascript
'use strict';

var React = require('react-native');
var Signature = require('react-native-signature-capture');

var {
  AppRegistry,
  TouchableHighlight,
  View,
  Dimensions
} = React;

var styles = {
  outerContainer: {
    flex: 1,
  },

  uiContainer: {
    position: 'absolute',
    flexDirection: 'row'
  },

  buttonStyles: {
    width: 100,
    height: 100,
    backgroundColor: 'red',
    margin: 10
  },

  sigContainer: {
    flexDirection: 'row',
    position: 'absolute',
    height: Dimensions.get('window').height,
    width: Dimensions.get('window').width,
  }
}

var NPMTest = React.createClass({

  _registerSignatureView (node) {
    this.sigNode = node;
  },

  _onImageSaved: function (result) {
    //result.encoded - for the base64 encoded png
    //result.pathName - for the file path name
    console.log(result);
  },

  _clearSignature: function () {
    Signature.clearSignature(this.sigNode);
  },

  _saveSignature: function () {
    Signature.saveSignature(this.sigNode);
  },

  render: function() {
    return (
      <View style={styles.outerContainer}>
        <View style={styles.sigContainer}>
          <Signature
            onImageSaved={::this._onImageSaved}
            register={::this._registerSignatureView}/>
        </View>
        <View style={styles.uiContainer}>
          <TouchableHighlight onPress={::this._clearSignature} style={styles.buttonStyles}>
            <Text style={{color:'brown'}}>Clear!</Text>
          </TouchableHighlight>

          <TouchableHighlight onPress={::this._saveSignature} style={styles.buttonStyles}>
            <Text style={{color:'brown'}}>Save!</Text>
          </TouchableHighlight>
        </View>
      </View>
    );
  }
});

AppRegistry.registerComponent('NPMTest', () => NPMTest);
```

Customize the UI to your needs.

## Setup

Use the `register` prop to register the signature view node for future use.

## Props

1. @Optional - `register` - `Function` - Will be called with the node reference that can then
be used to call the static methods, `clearSignature`, and `saveSignature`.

2. @Optional - `onImageSaved` - `Function` - Will be called any time an image is saved.
Will be passed image data:

```json
{
  "encoded": "for the base64 encoded png",
  "pathName": "for the file path name"
}
```

3. @Optional - `drawStyles` - `Object` - Styles to be applied to the base `Signature` component

## Static Manager Methods

There are 2 static methods:

1. `Signature.saveSignature(SignatureView)` - This will trigger a save image in the native module
that will result in the `onImageSaved` being called with the image data. Pass in the
desired signature view reference.

2. `Signature.clearSignature(SignatureView)` - This will clear all data from the desired
signature view reference.

Library used:
https://github.com/jharwig/PPSSignatureView

Based on:
https://github.com/RepairShopr/react-native-signature-capture
