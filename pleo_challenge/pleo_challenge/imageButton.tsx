import React, { Component } from 'react';
import { Image, TouchableOpacity, ImageSourcePropType, StyleProp, ViewStyle } from 'react-native';

export interface Props {
    onPress: (() => void)
    source: ImageSourcePropType
    imageSize: Size
    style: StyleProp<ViewStyle>
}

interface Size {
    height: number
    width: number
}

export class ImageButton extends Component<Props> {
    render() {
        return (
            <TouchableOpacity style={this.props.style}
                onPress={(_e) => { this.props.onPress() }}>
                <Image
                    style={{ height: this.props.imageSize.height, width: this.props.imageSize.width}}
                    source={this.props.source} />
            </TouchableOpacity>
        );
    }
}
