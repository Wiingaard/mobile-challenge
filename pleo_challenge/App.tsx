/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, { Component } from 'react';
import {
    SafeAreaView,
    StyleSheet
} from 'react-native';

import ExpensesList from './pleo_challenge/expensesList';
import HeaderView from './pleo_challenge/headerView';
import { Expense } from './pleo_challenge/networking';
import { ExpenseManager } from './pleo_challenge/expenseManager';

interface Props {

}

interface State {
    expenses: Expense[]
    loading: boolean
    didFinishInitialLoad: boolean
}

const initialState: State = {
    expenses: [],
    loading: true,
    didFinishInitialLoad: false
}

const expenseManager = new ExpenseManager()

export default class App extends Component<Props, State> {

    componentDidMount() {
        expenseManager.didUpdateExpenses = (expenses) => {
            this.setState((previousState) => {
                console.log(`Update state, expenses: ${expenses.length}`)
                return {
                    expenses: expenses,
                    loading: false,
                    didFinishInitialLoad: true
                }
            })
        }

        expenseManager.getInitialExpenses()
    }

    state = initialState

    render() {
        return (
            <SafeAreaView style={styles.mainArea}>
                <HeaderView
                    title="Expenses"
                />
                <ExpensesList
                    expenses={this.state.expenses}
                    initialLoad={!this.state.didFinishInitialLoad}
                    isScrolledCloseToBottom={(isClose) => { expenseManager.isScrolledCloseToBottom(isClose) }}
                />
            </SafeAreaView>
        );
    }
};

const styles = StyleSheet.create({
    mainArea: {
        flex: 1,
        flexDirection: "column",
        justifyContent: "flex-start"
    }
})
