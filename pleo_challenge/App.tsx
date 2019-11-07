/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, { Fragment } from 'react';
import {
    SafeAreaView,
    StyleSheet,
    ScrollView,
    View,
    Text,
    StatusBar,
    Button,
} from 'react-native';

import { Colors } from 'react-native/Libraries/NewAppScreen';

import { getExpenses } from './pleo_challenge/networking';

const App = () => {
    return (
        <Fragment>
            <StatusBar barStyle="dark-content" />
            <SafeAreaView>
                <View style={styles.sectionContainer}>
                    <Text style={styles.sectionTitle}>Hello</Text>
                    <Text style={styles.sectionDescription}>
                        Pleo challenge goes here
                    </Text>
                </View>
                <Button onPress={() => {
                    getExpenses(5, 0)
                        .then(expenses => {
                            const debugInfo = expenses.map(expense => { return expense.id }).join('\n')
                            alert(`Success\n${debugInfo}`)
                        }).catch(error => {
                            alert(`Error\n${error}`);
                        })
                }}
                    title="Get Expenses"
                />
            </SafeAreaView>
        </Fragment>
    );
};

const styles = StyleSheet.create({
    sectionContainer: {
        marginTop: 32,
        paddingHorizontal: 24,
    },
    sectionTitle: {
        fontSize: 24,
        fontWeight: '600',
        color: Colors.black,
    },
    sectionDescription: {
        marginTop: 8,
        fontSize: 18,
        fontWeight: '400',
        color: Colors.dark,
    }
});

export default App;
