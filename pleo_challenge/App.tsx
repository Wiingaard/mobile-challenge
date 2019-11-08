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
    Button,
} from 'react-native';

import ExpensesList from './pleo_challenge/expensesList';
import HeaderView from './pleo_challenge/headerView';
import { Expense, getExpenses } from './pleo_challenge/networking';

interface Props {

}

interface State {
    expenses: Expense[]
    loadingExpenses: boolean
}

const initialState: State = {
    expenses: [],
    loadingExpenses: true
}

export default class App extends Component<Props, State> {

    componentDidMount() {
        getExpenses(0, 1000)
            .then(expenses => {
                this.setState({
                    expenses: expenses,
                    loadingExpenses: false
                })
            })
    }

    state = initialState

    render() {
        return (
            <SafeAreaView style={{ flex: 1, flexDirection: "column", justifyContent: "flex-start" }}>
                <HeaderView title="Expenses" />
                <ExpensesList expenses={this.state.expenses} loading={this.state.loadingExpenses} />
            </SafeAreaView>
        );
    }
};
