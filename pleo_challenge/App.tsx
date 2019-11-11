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
    showExpenseDetail: Expense | null
}

const initialState: State = {
    expenses: [],
    loading: true,
    didFinishInitialLoad: false,
    showExpenseDetail: null
}

const expenseManager = new ExpenseManager()

export default class App extends Component<Props, State> {

    componentDidMount() {
        expenseManager.didUpdateExpenses = (expenses) => {
            this.setState({
                expenses: expenses,
                loading: false,
                didFinishInitialLoad: true,
                showExpenseDetail: null
            })
        }

        expenseManager.didUpdateExpense = (expense) => {
            this.setState(prevState => {
                return {
                    expenses: prevState.expenses.map(e => { return e.id == expense.id ? expense : e }),
                    loading: prevState.loading,
                    didFinishInitialLoad: prevState.didFinishInitialLoad,
                    showExpenseDetail: expense
                }
            })
        }

        expenseManager.getInitialExpenses()
    }

    setModalVisible(expense: (Expense | null)) {
        this.setState(prevState => {
            return {
                expenses: prevState.expenses,
                loading: prevState.loading,
                didFinishInitialLoad: prevState.didFinishInitialLoad,
                showExpenseDetail: expense
            }
        });
    }

    state = initialState

    render() {
        return (
            <SafeAreaView style={styles.mainArea}>
                <HeaderView
                    title="Expenses"
                    closeButtonAction={null}
                />

                <ExpensesList
                    expenses={this.state.expenses}
                    initialLoad={!this.state.didFinishInitialLoad}
                    isScrolledCloseToBottom={(isClose) => { expenseManager.isScrolledCloseToBottom(isClose) }}
                    didPressExpense={(expense) => { this.setModalVisible(expense) }}
                />

                <ExpenseDetail
                    expense={this.state.showExpenseDetail}
                    close={() => { this.setModalVisible(null) }}
                    expenseManager={expenseManager}
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
