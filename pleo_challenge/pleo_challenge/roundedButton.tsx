import React, { Component } from 'react';
import { Text, TouchableOpacity } from 'react-native';
import { buttonText } from './styles/textStyles';

export interface Props {
    onPress: (() => void)
    title: string
    isEnabled: boolean
}

export class RoundedButton extends Component<Props> {
    render() {
        return (
            <TouchableOpacity
                disabled={!this.props.isEnabled}
                style={{
                    justifyContent: "center",
                    alignItems: "center",
                    alignSelf: "flex-start",
                    height: 32,
                    borderRadius: 16,
                    backgroundColor: this.props.isEnabled ? "#61e496" : "#61e49677",
                }}
                onPress={(_e) => { this.props.onPress() }} >

                <Text style={[buttonText, {
                    color: "white",
                    paddingLeft: 24,
                    paddingRight: 24,
                }]}>
                    {this.props.title}
                </Text>

            </TouchableOpacity >
        );
    }
}
