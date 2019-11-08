import React, { Component } from 'react';
import { FlatList, StyleSheet, Text, View, ActivityIndicator } from 'react-native';
import { Expense } from './networking';

export interface Props {
    expenses: Expense[],
    loading: boolean
}

export default class ExpensesList extends Component<Props> {
    
    render() {
        if (this.props.loading) {
            return (
                <View style={styles.container}>
                    <ActivityIndicator style={{height: 300}}/>
                </View>
            )
        } else {
            return (
                <FlatList
                data={this.props.expenses}
                renderItem={({ item }) => <Text style={styles.item}>{item.amount.value}</Text>}
            />
            )
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: 22
    },
    item: {
        padding: 10,
        fontSize: 18,
        height: 44,
    },
})
