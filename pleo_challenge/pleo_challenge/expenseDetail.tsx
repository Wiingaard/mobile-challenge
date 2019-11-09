import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View } from 'react-native';

export interface Props {
    visibleExpenseDetail: string | null
    close: (() => void)
}

export class ExpenseDetail extends Component<Props> {
    render() {
        return (
            <View style={{ marginTop: 22 }}>
                <Modal
                    animationType="slide"
                    transparent={false}
                    visible={this.props.visibleExpenseDetail !== null}
                >
                    <View style={{ marginTop: 60 }}>
                        <View>
                            <Text>Hello Expense! {this.props.visibleExpenseDetail}</Text>

                            <TouchableHighlight
                                onPress={() => { this.props.close() }}>
                                <Text>Hide Modal</Text>
                            </TouchableHighlight>
                        </View>
                    </View>
                </Modal>
            </View>
        );
    }
}
