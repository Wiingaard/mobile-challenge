import React, { Component } from 'react';
import { Text, View, TextInput } from 'react-native';
import { Expense } from './networking';
import { titlePrimary } from './styles/textStyles';
import { RoundedButton } from './roundedButton';
import { whiteRoundedCard, cardContent } from './styles/cardStyles';
import { color } from './styles/color';

export interface Props {
    expense: Expense
    saveComment: ((comment: string) => void)
}

export interface State {
    comment: string
}

export default class ExpenseCommentCard extends Component<Props, State> {
    state = {
        comment: this.props.expense.comment
    }

    render() {
        return (
            <View style={whiteRoundedCard}>
                <View style={cardContent}>
                    <Text style={[titlePrimary, { marginBottom: 12 }]}>Comment</Text>
                    <TextInput
                        multiline={true}
                        placeholder="Type a comment here"
                        style={{ textAlignVertical: "top", marginBottom: 24 }}
                        onChangeText={(text) => this.setState({ comment: text })}
                        value={this.state.comment}
                    />
                    <RoundedButton
                        title={"Save"}
                        onPress={() => { this.props.saveComment(this.state.comment) }}
                        isEnabled={this.state.comment.length > 0 || this.props.expense.comment.length > 0}
                        color={color.pleoGreen}
                    />
                </View>
            </View>
        )
    }
}
