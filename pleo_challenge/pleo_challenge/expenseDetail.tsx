import React, { Component } from 'react';
import { Modal, SafeAreaView, View, ActivityIndicator, Alert } from 'react-native';
import HeaderView from './headerView';
import { ExpenseManager } from './expenseManager';
import { Expense } from './networking';
import ExpenseCard from './expenseCard';
import ExpenseCommentCard from './expenseCommentCard';

export interface Props {
    expense: Expense | null
    close: (() => void)
    expenseManager: ExpenseManager
}

export class ExpenseDetail extends Component<Props> {

    saveComment(comment: string) {
        this.props.expenseManager.addCommentToExpense(this.props.expense.id, comment)
            .then(_expense => {
                Alert.alert("Saved", "The comment was successfully saved")
            }).catch(error => {
                Alert.alert("Error", `An error happened while saving the comment:\n${error}`)
            })
    }

    render() {
        return (
            <Modal
                animationType="slide"
                transparent={false}
                visible={this.props.expense !== null} >
                <SafeAreaView>
                    <HeaderView
                        title=""
                        closeButtonAction={() => { this.props.close() }}
                    />
                    {this.props.expense === null
                        ? <ActivityIndicator />
                        : <View>
                            <ExpenseCard
                                expense={this.props.expense} />
                            <ExpenseCommentCard
                                expense={this.props.expense}
                                saveComment={(comment) => { this.saveComment(comment) }} />
                        </View>
                    }
                </SafeAreaView>
            </Modal>
        );
    }
}
