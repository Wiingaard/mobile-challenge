import React, { Component } from "react"
import { View, Text } from "react-native"

export interface Props {
    title: string;
}

export default class HeaderView extends Component<Props> {
    render() {
        return (
            <View style={{height: 60, justifyContent:"center", paddingLeft: 16}}>
                <Text style={{fontSize: 18, fontWeight: '600'}}>{this.props.title}</Text>
            </View>
        );
    }
};
