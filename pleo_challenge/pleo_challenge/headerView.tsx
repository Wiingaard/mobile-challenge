import React, { Component } from "react"
import { View, Text, StyleSheet } from "react-native"
import { ImageButton } from "./imageButton";

export interface Props {
    title: string;
    closeButtonAction: (() => void) | null
}

export default class HeaderView extends Component<Props> {
    render() {
        return (
            <View style={styles.bar}>
                <Text style={[styles.titleContainer, styles.titleText]}>
                    {this.props.title}
                </Text>
                {
                    this.props.closeButtonAction !== null
                        ? <ImageButton
                            onPress={() => { this.props.closeButtonAction() }}
                            source={require("./images/icon_close.png")}
                            imageSize={{ height: 20, width: 20 }}
                            style={styles.button}
                        />
                        : null
                }
            </View>
        );
    }
};

const styles = StyleSheet.create({
    titleText: {
        fontSize: 18,
        fontWeight: '600'
    },
    titleContainer: {
        position: "relative",
        flexGrow: 1,
        textAlign: "center"
    },
    button: {
        position: "absolute",
        left: 16,
        padding: 10
    },
    bar: {
        height: 60,
        justifyContent: "center",
        flexDirection: "row",
        alignItems: "center"
    }
})
