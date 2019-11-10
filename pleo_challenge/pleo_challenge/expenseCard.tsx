import React, { Component } from 'react';
import { Text, View } from 'react-native';
import { Expense } from './networking';
import { bodyPrimary, bodySecondary, titlePrimary } from './styles/textStyles';
import { whiteRoundedCard, cardContent } from './styles/cardStyles';

export interface Props {
    expense: Expense
}

export default class ExpenseCard extends Component<Props> {
    render() {
        return (
            <View style={whiteRoundedCard}>
                <View style={cardContent}>
                    <Text style={[titlePrimary, { marginBottom: 12 }]}>Expense</Text>
                    <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                        <Text style={[bodyPrimary, { marginBottom: 6 }]}>
                            {this.props.expense.user.first + " " + this.props.expense.user.last}
                        </Text>
                        <Text style={bodyPrimary}>
                            {this.props.expense.amount.value + " " + this.props.expense.amount.currency}
                        </Text>
                    </View>
                    <Text style={bodySecondary}>{this.props.expense.date}</Text>
                </View>
            </View>
        )
    }
}