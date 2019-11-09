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
import { ExpenseDetail } from './pleo_challenge/expenseDetail';

interface Props {

}

interface State {
    expenses: Expense[]
    loading: boolean
    didFinishInitialLoad: boolean
    visibleExpenseDetail: string | null
}

const initialState: State = {
    expenses: [],
    loading: true,
    didFinishInitialLoad: false,
    visibleExpenseDetail: null
}

const expenseManager = new ExpenseManager()

export default class App extends Component<Props, State> {

    componentDidMount() {
        expenseManager.didUpdateExpenses = (expenses) => {
            this.setState({
                expenses: expenses,
                loading: false,
                didFinishInitialLoad: true,
                visibleExpenseDetail: null
            })
        }

        expenseManager.getInitialExpenses()
    }

    setModalVisible(visibleExpense?: string) {
        this.setState(prevState => {
            return {
                expenses: prevState.expenses,
                loading: prevState.loading,
                didFinishInitialLoad: prevState.didFinishInitialLoad,
                visibleExpenseDetail: visibleExpense
            }
        });
    }

    state = initialState

    render() {
        return (
            <SafeAreaView style={styles.mainArea}>
                <HeaderView
                    title="Expenses"
                />

                <ExpenseDetail
                    visibleExpenseDetail={this.state.visibleExpenseDetail}
                    close={() => { this.setModalVisible(null) }}
                />

                <ExpensesList
                    expenses={this.state.expenses}
                    initialLoad={!this.state.didFinishInitialLoad}
                    isScrolledCloseToBottom={(isClose) => { expenseManager.isScrolledCloseToBottom(isClose) }}
                    didPressExpense={(expenseId) => { this.setModalVisible(expenseId) }}
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
