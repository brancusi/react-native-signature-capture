'use strict';

var React = require('react-native');

var {
  requireNativeComponent,
  DeviceEventEmitter,
  View
} = React;

var Component = requireNativeComponent('RSSignatureView', null);

var styles = {
  signatureBox: {
    flex: 1
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#F5FCFF',
  }
};

module.exports = React.createClass({
  propTypes: {
    pitchEnabled: React.PropTypes.bool
  },

  componentDidMount: function() {
    this.subscription = DeviceEventEmitter.addListener('onSaveEvent', this.props.onSaveEvent);
  },

  componentWillUnmount: function() {
    this.subscription.remove();
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Component style={styles.signatureBox} />
      </View>
    )
  }
});
