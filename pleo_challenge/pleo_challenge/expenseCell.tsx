import React, { Component } from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { Expense } from './networking';

export interface Props {
    expense: Expense
    onPress: ((Expense) => void)
}

export default class ExpenseCell extends Component<Props> {
    render() {
        return (
            <TouchableOpacity onPress={() => this.props.onPress(this.props.expense) }>
                <View style={styles.cell}>
                    <View style={[styles.circle, { backgroundColor: colorForCurrency(this.props.expense.amount.currency) }]} />
                    <View style={styles.container}>
                        <View style={styles.primaryTextContainer}>
                            <Text style={styles.primaryText}>{this.props.expense.user.first}</Text>
                            <Text style={styles.primaryText}>{this.props.expense.amount.value + " " + this.props.expense.amount.currency}</Text>
                        </View>
                        <Text style={styles.secondaryText}>{formattedDate(this.props.expense.date)}</Text>
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

function formattedDate(dateString: string): string {
    const date = new Date(dateString)
    return date.toLocaleDateString("en-US")
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
    primaryText: {
        fontSize: 14,
        fontWeight: "400"
    },
    secondaryText: {
        fontSize: 12,
        fontWeight: "200"
    },
    container: {
        flex: 1,
        justifyContent: "space-between",
        marginLeft: 16,
        marginRight: 16
    }
})
