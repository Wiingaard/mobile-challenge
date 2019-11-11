import React, { Component } from "react"
import { Text, StyleSheet, SafeAreaView } from "react-native"
import { ImageButton } from "./imageButton";
import { titlePrimary } from "./styles/textStyles";

export interface Props {
    title: string;
    closeButtonAction: (() => void) | null
}

export default class HeaderView extends Component<Props> {
    render() {
        return (
            <SafeAreaView style={styles.bar}>
                <Text style={[styles.titleContainer, titlePrimary]}>
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
            </SafeAreaView>
        );
    }
};

const styles = StyleSheet.create({
    titleContainer: {
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
