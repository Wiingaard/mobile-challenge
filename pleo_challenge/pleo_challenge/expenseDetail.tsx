import React, { Component } from 'react';
import { Modal, Text, TouchableHighlight, View } from 'react-native';
import { ImageButton } from './imageButton';
import HeaderView from './headerView';

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

                        <HeaderView
                            title="Expense detail"
                            closeButtonAction={() => { this.props.close() }}
                        />

                    </View>
                </Modal>
            </View>
        );
    }
}
