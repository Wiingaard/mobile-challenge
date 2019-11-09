import React, { Component } from 'react';
import { Modal, SafeAreaView, Text, View, ActivityIndicator, Button } from 'react-native';
import HeaderView from './headerView';
import { ExpenseManager } from './expenseManager';
import { Expense } from './networking';

export interface Props {
    expense: Expense | null
    close: (() => void)
    expenseManager: ExpenseManager
}

export class ExpenseDetail extends Component<Props> {
    
    render() {
        return (
            <Modal
                animationType="slide"
                transparent={false}
                visible={this.props.expense !== null} >
                <SafeAreaView>
                    <HeaderView
                        title="Expense detail"
                        closeButtonAction={() => { this.props.close() }}
                    />
                    {this.props.expense === null
                        ? <ActivityIndicator />
                        : <View>
                            <Text>{this.props.expense.user.first}</Text>
                            <Text>{this.props.expense.user.last}</Text>
                            <Text>{this.props.expense.amount.value}</Text>
                            <Button
                                onPress={(e) => { 
                                    this.props.expenseManager.addCommentToExpense(this.props.expense.id, "Awesome comment")
                                 }}
                                title="Add comment"
                            />
                            <Text>{this.props.expense.comment.length === 0 ? "No comment" : this.props.expense.comment}</Text>
                        </View>
                    }
                </SafeAreaView>
            </Modal>
        );
    }
}
