import React, { Component } from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { Expense } from './networking';
import { bodyPrimary, bodySecondary } from './styles/textStyles';
import { dateFormatted } from './date';
import { whiteRoundedCard } from './styles/cardStyles';

export interface Props {
    expense: Expense
    onPress: ((Expense) => void)
}

export default class ExpenseCell extends Component<Props> {
    render() {
        return (
            <TouchableOpacity onPress={() => this.props.onPress(this.props.expense)}>
                <View style={whiteRoundedCard}>
                    <View style={styles.cell}>
                        <View style={[styles.circle, { backgroundColor: colorForCurrency(this.props.expense.amount.currency) }]} />
                        <View style={styles.container}>
                            <View style={styles.primaryTextContainer}>
                                <Text style={bodyPrimary}>{this.props.expense.user.first}</Text>
                                <Text style={bodyPrimary}>{this.props.expense.amount.value + " " + this.props.expense.amount.currency}</Text>
                            </View>
                            <Text style={bodySecondary}>{dateFormatted(this.props.expense.date)}</Text>
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}

function colorForCurrency(currency: string): Color {
    switch (currency) {
        case "DKK": return "#61e496"
        case "EUR": return "#ee9456"
        case "GBP": return "#78ccf7"
        default: return "#e85e5a"
    }
}

type Color = "#61e496" | "#ee9456" | "#78ccf7" | "#e85e5a"

const styles = StyleSheet.create({
    cell: {
        flex: 1,
        flexDirection: "row",
        margin: 16,
    },
    circle: {
        height: 40,
        width: 40,
        borderRadius: 20
    },
    primaryTextContainer: {
        flexDirection: "row",
        justifyContent: "space-between"
    },
    container: {
        flex: 1,
        justifyContent: "space-between",
        marginLeft: 16,
        marginRight: 16
    }
})
