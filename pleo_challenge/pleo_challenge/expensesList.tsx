import React, { Component } from 'react';
import { FlatList, StyleSheet, View, ActivityIndicator } from 'react-native';
import { Expense } from './networking';
import ExpenseCell from './expenseCell';

export interface Props {
    expenses: Expense[],
    loading: boolean
}

export default class ExpensesList extends Component<Props> {

    handleExpensePress(expense: Expense) {
        alert(`Expense: ${expense.amount.value}`)
    }

    render() {
        if (this.props.loading) {
            return (
                <View style={styles.container}>
                    <ActivityIndicator style={{ height: 300 }} />
                </View>
            )
        } else {
            return (
                <FlatList
                    data={this.props.expenses}
                    renderItem={({ item }) => <ExpenseCell expense={item} onPress={this.handleExpensePress} />}
                />
            )
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: 22
    }
})
