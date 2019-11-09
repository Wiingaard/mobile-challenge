import React, { Component } from 'react';
import { FlatList, ActivityIndicator, NativeSyntheticEvent, NativeScrollEvent } from 'react-native';
import { Expense } from './networking';
import ExpenseCell from './expenseCell';

export interface Props {
    expenses: Expense[]
    initialLoad: boolean
    isScrolledCloseToBottom: ((isClose: boolean) => void)
    didPressExpense: ((expense: Expense) => void)
}

export default class ExpensesList extends Component<Props> {
    constructor(props) {
        super(props)
    }

    onScroll(event: NativeSyntheticEvent<NativeScrollEvent>) {
        this.props.isScrolledCloseToBottom(closeToButtom(event, 200))
    }

    render() {
        if (this.props.initialLoad) {
            return (
                <ActivityIndicator style={{ height: 300 }} />
            )
        } else {
            return (
                <FlatList 
                    onScroll={(e) => { this.onScroll(e) }}
                    data={this.props.expenses}
                    renderItem={({ item }) => <ExpenseCell expense={item} onPress={() => this.props.didPressExpense(item)} />}
                />
            )
        }
    }
}

function closeToButtom(event: NativeSyntheticEvent<NativeScrollEvent>, closeDistance: number): boolean {
    const scrollView = event.nativeEvent
    //console.log(`${scrollView.layoutMeasurement.height} + ${scrollView.contentOffset.y} >= ${scrollView.contentSize.height} - ${closeDistance}`)
    return scrollView.layoutMeasurement.height + scrollView.contentOffset.y >= scrollView.contentSize.height - closeDistance
}
