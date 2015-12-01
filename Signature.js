'use strict';

import React from 'react-native';

const {
  requireNativeComponent,
  NativeModules,
  DeviceEventEmitter
} = React;

const Component = requireNativeComponent('RSSignatureView', null);

export default class Signature extends React.Component {
  static propTypes = {
    pitchEnabled: React.PropTypes.bool
  };

  static clearSignature (node) {
    NativeModules.RSSignatureViewManager.clearSignature(React.findNodeHandle(node));
  }

  static saveSignature (node) {
    NativeModules.RSSignatureViewManager.saveSignature(React.findNodeHandle(node));
  }

  componentDidMount () {
    this.subscription = DeviceEventEmitter.addListener('imageSaved', this.props.onImageSaved);
  }

  componentWillUnmount () {
    this.subscription.remove();
  }

  render () {
    const register = this.props.register || function(){};

    return (
      <Component ref={register} style={{ flex: 1}}/>
    );
  }
}
